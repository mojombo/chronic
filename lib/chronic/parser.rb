require 'chronic/handlers'

module Chronic
  class Parser
    include Handlers

    # Hash of default configuration options.
    DEFAULT_OPTIONS = {
      :context => :future,
      :now => nil,
      :hours24 => nil,
      :guess => true,
      :ambiguous_time_range => 6,
      :endian_precedence    => [:middle, :little],
      :ambiguous_year_future_bias => 50
    }

    attr_accessor :now
    attr_reader :options

    # options - An optional Hash of configuration options:
    #        :context - If your string represents a birthday, you can set
    #                   this value to :past and if an ambiguous string is
    #                   given, it will assume it is in the past.
    #        :now - Time, all computations will be based off of time
    #               instead of Time.now.
    #        :hours24 - Time will be parsed as it would be 24 hour clock.
    #        :guess - By default the parser will guess a single point in time
    #                 for the given date or time. If you'd rather have the
    #                 entire time span returned, set this to false
    #                 and a Chronic::Span will be returned. Setting :guess to :end
    #                 will return last time from Span, to :middle for middle (same as just true)
    #                 and :begin for first time from span.
    #        :ambiguous_time_range - If an Integer is given, ambiguous times
    #                  (like 5:00) will be assumed to be within the range of
    #                  that time in the AM to that time in the PM. For
    #                  example, if you set it to `7`, then the parser will
    #                  look for the time between 7am and 7pm. In the case of
    #                  5:00, it would assume that means 5:00pm. If `:none`
    #                  is given, no assumption will be made, and the first
    #                  matching instance of that time will be used.
    #        :endian_precedence - By default, Chronic will parse "03/04/2011"
    #                 as the fourth day of the third month. Alternatively you
    #                 can tell Chronic to parse this as the third day of the
    #                 fourth month by setting this to [:little, :middle].
    #        :ambiguous_year_future_bias - When parsing two digit years
    #                 (ie 79) unlike Rubys Time class, Chronic will attempt
    #                 to assume the full year using this figure. Chronic will
    #                 look x amount of years into the future and past. If the
    #                 two digit year is `now + x years` it's assumed to be the
    #                 future, `now - x years` is assumed to be the past.
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @now = options.delete(:now) || Chronic.time_class.now
    end

    # Parse "text" with the given options
    # Returns either a Time or Chronic::Span, depending on the value of options[:guess]
    def parse(text)
      tokens = tokenize(text, options)
      span = tokens_to_span(tokens, options.merge(:text => text))

      puts "+#{'-' * 51}\n| #{tokens}\n+#{'-' * 51}" if Chronic.debug

      guess(span, options[:guess]) if span
    end

    # Clean up the specified text ready for parsing.
    #
    # Clean up the string by stripping unwanted characters, converting
    # idioms to their canonical form, converting number words to numbers
    # (three => 3), and converting ordinal words to numeric
    # ordinals (third => 3rd)
    #
    # text - The String text to normalize.
    #
    # Examples:
    #
    #   Chronic.pre_normalize('first day in May')
    #     #=> "1st day in may"
    #
    #   Chronic.pre_normalize('tomorrow after noon')
    #     #=> "next day future 12:00"
    #
    #   Chronic.pre_normalize('one hundred and thirty six days from now')
    #     #=> "136 days future this second"
    #
    # Returns a new String ready for Chronic to parse.
    def pre_normalize(text)
      text = text.to_s.downcase
      text.gsub!(/\b(\d{2})\.(\d{2})\.(\d{4})\b/, '\3 / \2 / \1')
      text.gsub!(/\b([ap])\.m\.?/, '\1m')
      text.gsub!(/(\s+|:\d{2}|:\d{2}\.\d{3})\-(\d{2}:?\d{2})\b/, '\1tzminus\2')
      text.gsub!(/\./, ':')
      text.gsub!(/([ap]):m:?/, '\1m')
      text.gsub!(/['"]/, '')
      text.gsub!(/,/, ' ')
      text.gsub!(/^second /, '2nd ')
      text.gsub!(/\bsecond (of|day|month|hour|minute|second)\b/, '2nd \1')
      text = Numerizer.numerize(text)
      text.gsub!(/([\/\-\,\@])/) { ' ' + $1 + ' ' }
      text.gsub!(/(?:^|\s)0(\d+:\d+\s*pm?\b)/, ' \1')
      text.gsub!(/\btoday\b/, 'this day')
      text.gsub!(/\btomm?orr?ow\b/, 'next day')
      text.gsub!(/\byesterday\b/, 'last day')
      text.gsub!(/\bnoon\b/, '12:00pm')
      text.gsub!(/\bmidnight\b/, '24:00')
      text.gsub!(/\bnow\b/, 'this second')
      text.gsub!('quarter', '15')
      text.gsub!('half', '30')
      text.gsub!(/(\d{1,2}) (to|till|prior to|before)\b/, '\1 minutes past')
      text.gsub!(/(\d{1,2}) (after|past)\b/, '\1 minutes future')
      text.gsub!(/\b(?:ago|before(?: now)?)\b/, 'past')
      text.gsub!(/\bthis (?:last|past)\b/, 'last')
      text.gsub!(/\b(?:in|during) the (morning)\b/, '\1')
      text.gsub!(/\b(?:in the|during the|at) (afternoon|evening|night)\b/, '\1')
      text.gsub!(/\btonight\b/, 'this night')
      text.gsub!(/\b\d+:?\d*[ap]\b/,'\0m')
      text.gsub!(/\b(\d{2})(\d{2})(am|pm)\b/, '\1:\2\3')
      text.gsub!(/(\d)([ap]m|oclock)\b/, '\1 \2')
      text.gsub!(/\b(hence|after|from)\b/, 'future')
      text.gsub!(/^\s?an? /i, '1 ')
      text.gsub!(/\b(\d{4}):(\d{2}):(\d{2})\b/, '\1 / \2 / \3') # DTOriginal
      text.gsub!(/\b0(\d+):(\d{2}):(\d{2}) ([ap]m)\b/, '\1:\2:\3 \4')
      text
    end

    # Guess a specific time within the given span.
    #
    # span - The Chronic::Span object to calcuate a guess from.
    #
    # Returns a new Time object.
    def guess(span, mode = :middle)
      return span if not mode
      return span.begin + span.width / 2 if span.width > 1 and (mode == true or mode == :middle)
      return span.end if mode == :end
      span.begin
    end

    # List of Handler definitions. See Chronic.parse for a list of options this
    # method accepts.
    #
    # options - An optional Hash of configuration options.
    #
    # Returns a Hash of Handler definitions.
    def definitions(options = {})
      options[:endian_precedence] ||= [:middle, :little]

      @@definitions ||= {
        :time => [
          Handler.new([:repeater_time, :repeater_day_portion?], nil)
        ],

        :date => [
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :repeater_time, [:separator_slash?, :separator_dash?], :time_zone, :scalar_year], :handle_generic),
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day], :handle_rdn_rmn_sd),
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :scalar_year], :handle_rdn_rmn_sd_sy),
          Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day], :handle_rdn_rmn_od),
          Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day, :scalar_year], :handle_rdn_rmn_od_sy),
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :separator_at?, 'time?'], :handle_rdn_rmn_sd),
          Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day, :separator_at?, 'time?'], :handle_rdn_rmn_od),
          Handler.new([:repeater_day_name, :ordinal_day, :separator_at?, 'time?'], :handle_rdn_od),
          Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_day, :repeater_time, :time_zone], :handle_generic),
          Handler.new([:ordinal_day], :handle_generic),
          Handler.new([:repeater_month_name, :scalar_day, :scalar_year], :handle_rmn_sd_sy),
          Handler.new([:repeater_month_name, :ordinal_day, :scalar_year], :handle_rmn_od_sy),
          Handler.new([:repeater_month_name, :scalar_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_sd_sy),
          Handler.new([:repeater_month_name, :ordinal_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_od_sy),
          Handler.new([:repeater_month_name, [:separator_slash?, :separator_dash?], :scalar_day, :separator_at?, 'time?'], :handle_rmn_sd),
          Handler.new([:repeater_time, :repeater_day_portion?, :separator_on?, :repeater_month_name, :scalar_day], :handle_rmn_sd_on),
          Handler.new([:repeater_month_name, :ordinal_day, :separator_at?, 'time?'], :handle_rmn_od),
          Handler.new([:ordinal_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_od_rmn_sy),
          Handler.new([:ordinal_day, :repeater_month_name, :separator_at?, 'time?'], :handle_od_rmn),
          Handler.new([:ordinal_day, :grabber?, :repeater_month, :separator_at?, 'time?'], :handle_od_rm),
          Handler.new([:scalar_year, :repeater_month_name, :ordinal_day], :handle_sy_rmn_od),
          Handler.new([:repeater_time, :repeater_day_portion?, :separator_on?, :repeater_month_name, :ordinal_day], :handle_rmn_od_on),
          Handler.new([:repeater_month_name, :scalar_year], :handle_rmn_sy),
          Handler.new([:scalar_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_sd_rmn_sy),
          Handler.new([:scalar_day, [:separator_slash?, :separator_dash?], :repeater_month_name, :separator_at?, 'time?'], :handle_sd_rmn),
          Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_day, :separator_at?, 'time?'], :handle_sy_sm_sd),
          Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month], :handle_sy_sm),
          Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_year], :handle_sm_sy),
          Handler.new([:scalar_day, [:separator_slash, :separator_dash], :repeater_month_name, [:separator_slash, :separator_dash], :scalar_year, :repeater_time?], :handle_sm_rmn_sy),
          Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar?, :time_zone], :handle_generic),
        ],

        :anchor => [
          Handler.new([:separator_on?, :grabber?, :repeater, :separator_at?, :repeater?, :repeater?], :handle_r),
          Handler.new([:grabber?, :repeater, :repeater, :separator?, :repeater?, :repeater?], :handle_r),
          Handler.new([:repeater, :grabber, :repeater], :handle_r_g_r)
        ],

        :arrow => [
          Handler.new([:scalar, :repeater, :pointer], :handle_s_r_p),
          Handler.new([:scalar, :repeater, :separator_and?, :scalar, :repeater, :pointer, :separator_at?, 'anchor'], :handle_s_r_a_s_r_p_a),
          Handler.new([:pointer, :scalar, :repeater], :handle_p_s_r),
          Handler.new([:scalar, :repeater, :pointer, :separator_at?, 'anchor'], :handle_s_r_p_a)
        ],

        :narrow => [
          Handler.new([:ordinal, :repeater, :separator_in, :repeater], :handle_o_r_s_r),
          Handler.new([:ordinal, :repeater, :grabber, :repeater], :handle_o_r_g_r)
        ]
      }

      endians = [
        Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_day, [:separator_slash, :separator_dash], :scalar_year, :separator_at?, 'time?'], :handle_sm_sd_sy),
        Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_day, :separator_at?, 'time?'], :handle_sm_sd),
        Handler.new([:scalar_day, [:separator_slash, :separator_dash], :scalar_month, :separator_at?, 'time?'], :handle_sd_sm),
        Handler.new([:scalar_day, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_year, :separator_at?, 'time?'], :handle_sd_sm_sy)
      ]

      case endian = Array(options[:endian_precedence]).first
      when :little
        @@definitions.merge(:endian => endians.reverse)
      when :middle
        @@definitions.merge(:endian => endians)
      else
        raise ArgumentError, "Unknown endian option '#{endian}'"
      end
    end

    private

    def tokenize(text, options)
      text = pre_normalize(text)
      tokens = text.split(' ').map { |word| Token.new(word) }
      [Repeater, Grabber, Pointer, Scalar, Ordinal, Separator, Sign, TimeZone].each do |tok|
        tok.scan(tokens, options)
      end
      tokens.select { |token| token.tagged? }
    end

    def tokens_to_span(tokens, options)
      definitions = definitions(options)

      (definitions[:endian] + definitions[:date]).each do |handler|
        if handler.match(tokens, definitions)
          good_tokens = tokens.select { |o| !o.get_tag Separator }
          return handler.invoke(:date, good_tokens, self, options)
        end
      end

      definitions[:anchor].each do |handler|
        if handler.match(tokens, definitions)
          good_tokens = tokens.select { |o| !o.get_tag Separator }
          return handler.invoke(:anchor, good_tokens, self, options)
        end
      end

      definitions[:arrow].each do |handler|
        if handler.match(tokens, definitions)
          good_tokens = tokens.reject { |o| o.get_tag(SeparatorAt) || o.get_tag(SeparatorSlash) || o.get_tag(SeparatorDash) || o.get_tag(SeparatorComma) || o.get_tag(SeparatorAnd) }
          return handler.invoke(:arrow, good_tokens, self, options)
        end
      end

      definitions[:narrow].each do |handler|
        if handler.match(tokens, definitions)
          return handler.invoke(:narrow, tokens, self, options)
        end
      end

      puts "-none" if Chronic.debug
      return nil
    end
  end
end
