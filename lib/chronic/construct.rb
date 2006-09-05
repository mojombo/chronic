module Chronic

	class << self
	  
	  def definitions #:nodoc:
	    @definitions ||= 
      {:time => [Handler.new([:repeater_time, :repeater_day_portion?], nil)],
        
       :date => [Handler.new([:repeater_month_name, :scalar_day, :scalar_year], :handle_rmn_sd_sy),
                 Handler.new([:repeater_month_name, :scalar_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_sd_sy),
                 Handler.new([:repeater_month_name, :scalar_day, :separator_at?, 'time?'], :handle_rmn_sd),
                 Handler.new([:repeater_month_name, :ordinal_day, :separator_at?, 'time?'], :handle_rmn_od),
                 Handler.new([:repeater_month_name, :scalar_year], :handle_rmn_sy),
                 Handler.new([:scalar_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_sd_rmn_sy),
                 Handler.new([:scalar_month, :separator_slash_or_dash, :scalar_day, :separator_slash_or_dash, :scalar_year, :separator_at?, 'time?'], :handle_sm_sd_sy),
                 Handler.new([:scalar_day, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar_year, :separator_at?, 'time?'], :handle_sd_sm_sy),
                 Handler.new([:scalar_year, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar_day, :separator_at?, 'time?'], :handle_sy_sm_sd),
                 Handler.new([:scalar_month, :separator_slash_or_dash, :scalar_year], :handle_sm_sy)],
                 
       :anchor => [Handler.new([:grabber?, :repeater, :separator_at?, :repeater?, :repeater?], :handle_r),
                   Handler.new([:repeater, :grabber, :repeater], :handle_r_g_r)],
                   
       :arrow => [Handler.new([:scalar, :repeater, :pointer], :handle_s_r_p),
                  Handler.new([:pointer, :scalar, :repeater], :handle_p_s_r),
                  Handler.new([:scalar, :repeater, :pointer, 'anchor'], :handle_s_r_p_a)],
                  
       :narrow => [Handler.new([:ordinal, :repeater, :separator_in, :repeater], :handle_o_r_s_r),
                   Handler.new([:ordinal, :repeater, :grabber, :repeater], :handle_o_r_g_r)]
      }
    end
    
    def tokens_to_span(tokens, options) #:nodoc:                   
      # maybe it's a specific date
      
      self.definitions[:date].each do |handler|
        if handler.match(tokens, self.definitions)
          good_tokens = tokens.select { |o| !o.get_tag Separator }
          return self.send(handler.handler_method, good_tokens, options)
        end
      end
            
      # I guess it's not a specific date, maybe it's just an anchor
            
      self.definitions[:anchor].each do |handler|
        if handler.match(tokens, self.definitions)
          good_tokens = tokens.select { |o| !o.get_tag Separator }
          return self.send(handler.handler_method, good_tokens, options)
        end
      end
            
      # not an anchor, perhaps it's an arrow
      
      self.definitions[:arrow].each do |handler|
        if handler.match(tokens, self.definitions)
          good_tokens = tokens.reject { |o| o.get_tag(SeparatorAt) || o.get_tag(SeparatorSlashOrDash) || o.get_tag(SeparatorComma) }
          return self.send(handler.handler_method, good_tokens, options)
        end
      end
      
      # not an arrow, let's hope it's an narrow
      
      self.definitions[:narrow].each do |handler|
        if handler.match(tokens, self.definitions)
          #good_tokens = tokens.select { |o| !o.get_tag Separator }
          return self.send(handler.handler_method, tokens, options)
        end
      end
      
      # I guess you're out of luck!
      return nil
    end
    
    #--------------
    
    def day_or_time(day_start, time_tokens, options)
      outer_span = Span.new(day_start, day_start + (24 * 60 * 60))
      
      if !time_tokens.empty?
        @now = outer_span.begin
        time = get_anchor(dealias_and_disambiguate_times(time_tokens, options), options)
        return time
      else
        return outer_span
      end
    end
    
    #--------------
    
    def handle_m_d(month, day, time_tokens, options) #:nodoc:
      month.start = @now
      span = month.next(options[:context])
      
      day_start = Time.local(span.begin.year, span.begin.month, day)
      
      day_or_time(day_start, time_tokens, options)
    end
    
    def handle_rmn_sd(tokens, options) #:nodoc:
      handle_m_d(tokens[0].get_tag(RepeaterMonthName), tokens[1].get_tag(ScalarDay).type, tokens[2..tokens.size], options)
    end
    
    def handle_rmn_od(tokens, options) #:nodoc:
      handle_m_d(tokens[0].get_tag(RepeaterMonthName), tokens[1].get_tag(OrdinalDay).type, tokens[2..tokens.size], options)
    end
    
    def handle_rmn_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(RepeaterMonthName).index
      year = tokens[1].get_tag(ScalarYear).type
      
      if month == 12
        next_month_year = year + 1
        next_month_month = 1
      else
        next_month_year = year
        next_month_month = month + 1
      end
      
      begin
        Span.new(Time.local(year, month), Time.local(next_month_year, next_month_month))
      rescue ArgumentError
        nil
      end
    end
    
    def handle_rmn_sd_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(RepeaterMonthName).index
      day = tokens[1].get_tag(ScalarDay).type
      year = tokens[2].get_tag(ScalarYear).type
      
      time_tokens = tokens.last(tokens.size - 3)
      
      begin
        day_start = Time.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end
    
    def handle_sd_rmn_sy(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      time_tokens = tokens.last(tokens.size - 3)
      self.handle_rmn_sd_sy(new_tokens + time_tokens, options)
    end
    
    def handle_sm_sd_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(ScalarMonth).type
      day = tokens[1].get_tag(ScalarDay).type
      year = tokens[2].get_tag(ScalarYear).type
      
      time_tokens = tokens.last(tokens.size - 3)
      
      begin
        day_start = Time.local(year, month, day) #:nodoc:
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end
    
    def handle_sd_sm_sy(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      time_tokens = tokens.last(tokens.size - 3)
      self.handle_sm_sd_sy(new_tokens + time_tokens, options)
    end
    
    def handle_sy_sm_sd(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[2], tokens[0]]
      time_tokens = tokens.last(tokens.size - 3)
      self.handle_sm_sd_sy(new_tokens + time_tokens, options)
    end
    
    def handle_sm_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(ScalarMonth).type
      year = tokens[1].get_tag(ScalarYear).type
      
      if month == 12
        next_month_year = year + 1
        next_month_month = 1
      else
        next_month_year = year
        next_month_month = month + 1
      end
      
      begin
        Span.new(Time.local(year, month), Time.local(next_month_year, next_month_month))
      rescue ArgumentError
        nil
      end
    end
    
    # anchors
    
    def handle_r(tokens, options) #:nodoc:
      dd_tokens = dealias_and_disambiguate_times(tokens, options)
      self.get_anchor(dd_tokens, options)
    end
    
    def handle_r_g_r(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      self.handle_r(new_tokens, options)
    end
    
    # arrows
    
    def handle_srp(tokens, span, options) #:nodoc:
      distance = tokens[0].get_tag(Scalar).type
      repeater = tokens[1].get_tag(Repeater)
      pointer = tokens[2].get_tag(Pointer).type
      
      repeater.offset(span, distance, pointer)
    end
    
    def handle_s_r_p(tokens, options) #:nodoc:
      repeater = tokens[1].get_tag(Repeater)
      
      span = 
      case true
      when [RepeaterYear, RepeaterSeason, RepeaterSeasonName, RepeaterMonth, RepeaterMonthName, RepeaterFortnight, RepeaterWeek].include?(repeater.class)
        self.parse("today", :guess => false, :now => @now)
      when [RepeaterWeekend, RepeaterDay, RepeaterDayName, RepeaterDayPortion, RepeaterHour].include?(repeater.class)
        self.parse("this minute", :guess => false, :now => @now)
      when [RepeaterMinute, RepeaterSecond].include?(repeater.class)
        self.parse("this second", :guess => false, :now => @now)
      else
        raise(ChronicPain, "Invalid repeater: #{repeater.class}")
      end
      
      self.handle_srp(tokens, span, options)
    end
    
    def handle_p_s_r(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[2], tokens[0]]
      self.handle_s_r_p(new_tokens, options)
    end
    
    def handle_s_r_p_a(tokens, options) #:nodoc:
      anchor_span = get_anchor(tokens[3..tokens.size - 1], options)
      self.handle_srp(tokens, anchor_span, options)
    end
    
    # narrows
    
    def handle_orr(tokens, outer_span, options) #:nodoc:
      repeater = tokens[1].get_tag(Repeater)
      repeater.start = outer_span.begin - 1
      ordinal = tokens[0].get_tag(Ordinal).type
      span = nil
      ordinal.times do
        span = repeater.next(:future)
        if span.begin > outer_span.end
          span = nil
          break
        end
      end
      span
    end
    
    def handle_o_r_s_r(tokens, options) #:nodoc:
      outer_span = get_anchor([tokens[3]], options)
      handle_orr(tokens[0..1], outer_span, options)
    end
    
    def handle_o_r_g_r(tokens, options) #:nodoc:
      outer_span = get_anchor(tokens[2..3], options)
      handle_orr(tokens[0..1], outer_span, options)
    end
    
    # support methods
    
    def get_anchor(tokens, options) #:nodoc:
      grabber = Grabber.new(:this)
      pointer = :future
      
      repeaters = self.get_repeaters(tokens)
      repeaters.size.times { tokens.pop }
        
      if tokens.last && tokens.last.get_tag(Grabber)
        grabber = tokens.last.get_tag(Grabber)
        tokens.pop
      end
      
      head = repeaters.shift
      head.start = @now
      
      case grabber.type
        when :last: outer_span = head.next(:past)
        when :this: outer_span = head.this(options[:context])
        when :next: outer_span = head.next(:future)
        else raise(ChronicPain, "Invalid grabber")
      end
      
      anchor = find_within(repeaters, outer_span, pointer)
    end
    
    def get_repeaters(tokens) #:nodoc:
      repeaters = []
		  tokens.reverse.each do |token|
		    if t = token.get_tag(Repeater)
          repeaters << t
        else
          break
        end
      end
      repeaters.sort.reverse
    end
    
    # Recursively finds repeaters within other repeaters.
    # Returns a Span representing the innermost time span
    # or nil if no repeater union could be found
    def find_within(tags, span, pointer) #:nodoc:
      return span if tags.empty?
      
      head, *rest = tags
      head.start = pointer == :future ? span.begin : span.end
      h = head.next(pointer)
      
      if span.include?(h.begin) || span.include?(h.end)
        return find_within(rest, h, pointer)
      else
        return nil
      end
    end
    
    def dealias_and_disambiguate_times(tokens, options) #:nodoc:
      # handle aliases of am/pm
      # 5:00 in the morning => 5:00 am
      # 7:00 in the evening => 7:00 pm
      #ttokens = []
      tokens.each_with_index do |t0, i|
        t1 = tokens[i + 1]
        if t1 && (t1tag = t1.get_tag(RepeaterDayPortion)) && t0.get_tag(RepeaterTime)
          if [:morning].include?(t1tag.type)
            t1.untag(RepeaterDayPortion)
            t1.tag(RepeaterDayPortion.new(:am))
          elsif [:afternoon, :evening, :night].include?(t1tag.type)
            t1.untag(RepeaterDayPortion)
            t1.tag(RepeaterDayPortion.new(:pm))
          end
        end
      end
      #tokens = ttokens
            
      # handle ambiguous times if :ambiguous_time_range is specified
      if options[:ambiguous_time_range] != :none
        ttokens = []
        tokens.each_with_index do |t0, i|
          ttokens << t0
          t1 = tokens[i + 1]
          if t0.get_tag(RepeaterTime) && t0.get_tag(RepeaterTime).type.ambiguous? && (!t1 || !t1.get_tag(RepeaterDayPortion))
            distoken = Token.new('disambiguator')
            distoken.tag(RepeaterDayPortion.new(options[:ambiguous_time_range]))
            ttokens << distoken
          end
        end
        tokens = ttokens
      end
      
      tokens
    end
    
  end
  
  class Handler #:nodoc:
    attr_accessor :pattern, :handler_method
    
    def initialize(pattern, handler_method)
      @pattern = pattern
      @handler_method = handler_method
    end
    
    def constantize(name)
      camel = name.to_s.gsub(/(^|_)(.)/) { $2.upcase }
      ::Chronic.module_eval(camel, __FILE__, __LINE__)
    end
    
    def match(tokens, definitions)
      token_index = 0
      @pattern.each do |element|
        name = element.to_s
        optional = name.reverse[0..0] == '?'
        name = name.chop if optional
        if element.instance_of? Symbol
          klass = constantize(name)
          match = tokens[token_index] && !tokens[token_index].tags.select { |o| o.kind_of?(klass) }.empty?
          return false if !match && !optional
          (token_index += 1; next) if match
          next if !match && optional
        elsif element.instance_of? String
          return true if optional && token_index == tokens.size
          sub_handlers = definitions[name.intern] || raise(ChronicPain, "Invalid subset #{name} specified")
          sub_handlers.each do |sub_handler|
            return true if sub_handler.match(tokens[token_index..tokens.size], definitions)
          end
          return false
        else
          raise(ChronicPain, "Invalid match type: #{element.class}")
        end
      end
      return false if token_index != tokens.size
      return true
    end
  end
  
end