module Chronic
  module Handlers
    module_function

    # Handle month/day
    def handle_m_d(month, day, time_tokens, options) #:nodoc:
      month.start = Chronic.now
      span = month.this(options[:context])

      day_start = Chronic.time_class.local(span.begin.year, span.begin.month, day)

      day_or_time(day_start, time_tokens, options)
    end

    # Handle repeater-month-name/scalar-day
    def handle_rmn_sd(tokens, options) #:nodoc:
      handle_m_d(tokens[0].get_tag(RepeaterMonthName), tokens[1].get_tag(ScalarDay).type, tokens[2..tokens.size], options)
    end

    # Handle repeater-month-name/scalar-day with separator-on
    def handle_rmn_sd_on(tokens, options) #:nodoc:
      if tokens.size > 3
        handle_m_d(tokens[2].get_tag(RepeaterMonthName), tokens[3].get_tag(ScalarDay).type, tokens[0..1], options)
      else
        handle_m_d(tokens[1].get_tag(RepeaterMonthName), tokens[2].get_tag(ScalarDay).type, tokens[0..0], options)
      end
    end

    # Handle repeater-month-name/ordinal-day
    def handle_rmn_od(tokens, options) #:nodoc:
      handle_m_d(tokens[0].get_tag(RepeaterMonthName), tokens[1].get_tag(OrdinalDay).type, tokens[2..tokens.size], options)
    end

    # Handle ordinal-day/repeater-month-name
    def handle_od_rmn(tokens, options) #:nodoc:
      handle_m_d(tokens[1].get_tag(RepeaterMonthName), tokens[0].get_tag(OrdinalDay).type, tokens[2..tokens.size], options)
    end

    # Handle repeater-month-name/ordinal-day with separator-on
    def handle_rmn_od_on(tokens, options) #:nodoc:
      if tokens.size > 3
        handle_m_d(tokens[2].get_tag(RepeaterMonthName), tokens[3].get_tag(OrdinalDay).type, tokens[0..1], options)
      else
        handle_m_d(tokens[1].get_tag(RepeaterMonthName), tokens[2].get_tag(OrdinalDay).type, tokens[0..0], options)
      end
    end

    # Handle repeater-month-name/scalar-year
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
        Span.new(Chronic.time_class.local(year, month), Chronic.time_class.local(next_month_year, next_month_month))
      rescue ArgumentError
        nil
      end
    end

    # Handle generic timestamp
    def handle_rdn_rmn_sd_t_tz_sy(tokens, options) #:nodoc:
      t = Chronic.time_class.parse(options[:text])
      Span.new(t, t + 1)
    end

    # Handle repeater-month-name/scalar-day/scalar-year
    def handle_rmn_sd_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(RepeaterMonthName).index
      day = tokens[1].get_tag(ScalarDay).type
      year = tokens[2].get_tag(ScalarYear).type

      time_tokens = tokens.last(tokens.size - 3)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle repeater-month-name/ordinal-day/scalar-year
    def handle_rmn_od_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(RepeaterMonthName).index
      day = tokens[1].get_tag(OrdinalDay).type
      year = tokens[2].get_tag(ScalarYear).type

      time_tokens = tokens.last(tokens.size - 3)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle scalar-day/repeater-month-name/scalar-year
    def handle_sd_rmn_sy(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      time_tokens = tokens.last(tokens.size - 3)
      handle_rmn_sd_sy(new_tokens + time_tokens, options)
    end

    # Handle scalar-month/scalar-day/scalar-year (endian middle)
    def handle_sm_sd_sy(tokens, options) #:nodoc:
      month = tokens[0].get_tag(ScalarMonth).type
      day = tokens[1].get_tag(ScalarDay).type
      year = tokens[2].get_tag(ScalarYear).type

      time_tokens = tokens.last(tokens.size - 3)

      begin
        day_start = Chronic.time_class.local(year, month, day) #:nodoc:
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle scalar-day/scalar-month/scalar-year (endian little)
    def handle_sd_sm_sy(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      time_tokens = tokens.last(tokens.size - 3)
      handle_sm_sd_sy(new_tokens + time_tokens, options)
    end

    # Handle scalar-year/scalar-month/scalar-day
    def handle_sy_sm_sd(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[2], tokens[0]]
      time_tokens = tokens.last(tokens.size - 3)
      handle_sm_sd_sy(new_tokens + time_tokens, options)
    end

    # Handle scalar-month/scalar-year
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
        Span.new(Chronic.time_class.local(year, month), Chronic.time_class.local(next_month_year, next_month_month))
      rescue ArgumentError
        nil
      end
    end

    # anchors

    # Handle repeaters
    def handle_r(tokens, options) #:nodoc:
      dd_tokens = dealias_and_disambiguate_times(tokens, options)
      get_anchor(dd_tokens, options)
    end

    # Handle repeater/grabber/repeater
    def handle_r_g_r(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      handle_r(new_tokens, options)
    end

    # arrows

    # Handle scalar/repeater/pointer helper
    def handle_srp(tokens, span, options) #:nodoc:
      distance = tokens[0].get_tag(Scalar).type
      repeater = tokens[1].get_tag(Repeater)
      pointer = tokens[2].get_tag(Pointer).type

      repeater.offset(span, distance, pointer)
    end

    # Handle scalar/repeater/pointer
    def handle_s_r_p(tokens, options) #:nodoc:
      repeater = tokens[1].get_tag(Repeater)
      span = Span.new(Chronic.now, Chronic.now + 1)

      handle_srp(tokens, span, options)
    end

    # Handle pointer/scalar/repeater
    def handle_p_s_r(tokens, options) #:nodoc:
      new_tokens = [tokens[1], tokens[2], tokens[0]]
      handle_s_r_p(new_tokens, options)
    end

    # Handle scalar/repeater/pointer/anchor
    def handle_s_r_p_a(tokens, options) #:nodoc:
      anchor_span = get_anchor(tokens[3..tokens.size - 1], options)
      handle_srp(tokens, anchor_span, options)
    end

    # narrows

    # Handle oridinal repeaters
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

    # Handle ordinal/repeater/separator/repeater
    def handle_o_r_s_r(tokens, options) #:nodoc:
      outer_span = get_anchor([tokens[3]], options)
      handle_orr(tokens[0..1], outer_span, options)
    end

    # Handle ordinal/repeater/grabber/repeater
    def handle_o_r_g_r(tokens, options) #:nodoc:
      outer_span = get_anchor(tokens[2..3], options)
      handle_orr(tokens[0..1], outer_span, options)
    end

    # support methods

    def day_or_time(day_start, time_tokens, options)
      outer_span = Span.new(day_start, day_start + (24 * 60 * 60))

      if !time_tokens.empty?
        Chronic.now = outer_span.begin
        get_anchor(dealias_and_disambiguate_times(time_tokens, options), options)
      else
        outer_span
      end
    end

    def get_anchor(tokens, options) #:nodoc:
      grabber = Grabber.new(:this)
      pointer = :future

      repeaters = get_repeaters(tokens)
      repeaters.size.times { tokens.pop }

      if tokens.first && tokens.first.get_tag(Grabber)
        grabber = tokens.first.get_tag(Grabber)
        tokens.pop
      end

      head = repeaters.shift
      head.start = Chronic.now

      case grabber.type
        when :last
          outer_span = head.next(:past)
        when :this
          if options[:context] != :past and repeaters.size > 0
            outer_span = head.this(:none)
          else
            outer_span = head.this(options[:context])
          end
        when :next
          outer_span = head.next(:future)
        else raise(ChronicPain, "Invalid grabber")
      end

      puts "--#{outer_span}" if Chronic.debug
      find_within(repeaters, outer_span, pointer)
    end

    def get_repeaters(tokens) #:nodoc:
      repeaters = []
      tokens.each do |token|
        if t = token.get_tag(Repeater)
          repeaters << t
        end
      end
      repeaters.sort.reverse
    end

    # Recursively finds repeaters within other repeaters.
    # Returns a Span representing the innermost time span
    # or nil if no repeater union could be found
    def find_within(tags, span, pointer) #:nodoc:
      puts "--#{span}" if Chronic.debug
      return span if tags.empty?

      head, *rest = tags
      head.start = pointer == :future ? span.begin : span.end
      h = head.this(:none)

      if span.cover?(h.begin) || span.cover?(h.end)
        find_within(rest, h, pointer)
      end
    end

    def dealias_and_disambiguate_times(tokens, options) #:nodoc:
      # handle aliases of am/pm
      # 5:00 in the morning -> 5:00 am
      # 7:00 in the evening -> 7:00 pm

      day_portion_index = nil
      tokens.each_with_index do |t, i|
        if t.get_tag(RepeaterDayPortion)
          day_portion_index = i
          break
        end
      end

      time_index = nil
      tokens.each_with_index do |t, i|
        if t.get_tag(RepeaterTime)
          time_index = i
          break
        end
      end

      if (day_portion_index && time_index)
        t1 = tokens[day_portion_index]
        t1tag = t1.get_tag(RepeaterDayPortion)

        if [:morning].include?(t1tag.type)
          puts '--morning->am' if Chronic.debug
          t1.untag(RepeaterDayPortion)
          t1.tag(RepeaterDayPortion.new(:am))
        elsif [:afternoon, :evening, :night].include?(t1tag.type)
          puts "--#{t1tag.type}->pm" if Chronic.debug
          t1.untag(RepeaterDayPortion)
          t1.tag(RepeaterDayPortion.new(:pm))
        end
      end

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

  class Handler
    # @return [Array] A list of patterns
    attr_accessor :pattern

    # @return [Symbol] The method which handles this list of patterns.
    #   This method should exist inside the {Handlers} module
    attr_accessor :handler_method

    # @param [Array]  pattern A list of patterns to match tokens against
    # @param [Symbol] handler_method The method to be invoked when patterns
    #   are matched. This method should exist inside the {Handlers} module
    def initialize(pattern, handler_method)
      @pattern = pattern
      @handler_method = handler_method
    end

    # @param [#to_s]  The snake_case name representing a Chronic constant
    # @return [Class] The class represented by `name`
    # @raise [NameError] Raises if this constant could not be found
    def constantize(name)
      Chronic.const_get name.to_s.gsub(/(^|_)(.)/) { $2.upcase }
    end

    # @param [Array] tokens
    # @param [Hash]  definitions
    # @return [Boolean]
    # @see Chronic.tokens_to_span
    def match(tokens, definitions)
      token_index = 0
      @pattern.each do |element|
        name = element.to_s
        optional = name[-1, 1] == '?'
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

    # @param [Handler]  The handler to compare
    # @return [Boolean] True if these handlers match
    def ==(other)
      @pattern == other.pattern
    end
  end

end
