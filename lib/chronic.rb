require 'time'
require 'date'

# Parse natural language dates and times into Time or Chronic::Span objects.
#
# Examples:
#
#   require 'chronic'
#
#   Time.now   #=> Sun Aug 27 23:18:25 PDT 2006
#
#   Chronic.parse('tomorrow')
#     #=> Mon Aug 28 12:00:00 PDT 2006
#
#   Chronic.parse('monday', :context => :past)
#     #=> Mon Aug 21 12:00:00 PDT 2006
#
#   Chronic.parse('this tuesday 5:00')
#     #=> Tue Aug 29 17:00:00 PDT 2006
#
#   Chronic.parse('this tuesday 5:00', :ambiguous_time_range => :none)
#     #=> Tue Aug 29 05:00:00 PDT 2006
#
#   Chronic.parse('may 27th', :now => Time.local(2000, 1, 1))
#     #=> Sat May 27 12:00:00 PDT 2000
#
#   Chronic.parse('may 27th', :guess => false)
#     #=> Sun May 27 00:00:00 PDT 2007..Mon May 28 00:00:00 PDT 2007
module Chronic
  VERSION = "0.8.0"

  class << self

    # Returns true when debug mode is enabled.
    attr_accessor :debug

    # Examples:
    #
    #   require 'chronic'
    #   require 'active_support/time'
    #
    #   Time.zone = 'UTC'
    #   Chronic.time_class = Time.zone
    #   Chronic.parse('June 15 2006 at 5:54 AM')
    #     # => Thu, 15 Jun 2006 05:45:00 UTC +00:00
    #
    # Returns The Time class Chronic uses internally.
    attr_accessor :time_class

    # The current Time Chronic is using to base from.
    #
    # Examples:
    #
    #   Time.now #=> 2011-06-06 14:13:43 +0100
    #   Chronic.parse('yesterday') #=> 2011-06-05 12:00:00 +0100
    #
    #   now = Time.local(2025, 12, 24)
    #   Chronic.parse('tomorrow', :now => now) #=> 2025-12-25 12:00:00 +0000
    #
    # Returns a Time object.
    attr_accessor :now
  end

  self.debug = false
  self.time_class = Time

  autoload :Handler, 'chronic/handler'
  autoload :Handlers, 'chronic/handlers'
  autoload :MiniDate, 'chronic/mini_date'
  autoload :Tag, 'chronic/tag'
  autoload :Span, 'chronic/span'
  autoload :Token, 'chronic/token'
  autoload :Grabber, 'chronic/grabber'
  autoload :Pointer, 'chronic/pointer'
  autoload :Scalar, 'chronic/scalar'
  autoload :Ordinal, 'chronic/ordinal'
  autoload :OrdinalDay, 'chronic/ordinal'
  autoload :Separator, 'chronic/separator'
  autoload :TimeZone, 'chronic/time_zone'
  autoload :Numerizer, 'chronic/numerizer'
  autoload :Season, 'chronic/season'

  autoload :Repeater, 'chronic/repeater'
  autoload :RepeaterYear, 'chronic/repeaters/repeater_year'
  autoload :RepeaterSeason, 'chronic/repeaters/repeater_season'
  autoload :RepeaterSeasonName, 'chronic/repeaters/repeater_season_name'
  autoload :RepeaterMonth, 'chronic/repeaters/repeater_month'
  autoload :RepeaterMonthName, 'chronic/repeaters/repeater_month_name'
  autoload :RepeaterFortnight, 'chronic/repeaters/repeater_fortnight'
  autoload :RepeaterWeek, 'chronic/repeaters/repeater_week'
  autoload :RepeaterWeekend, 'chronic/repeaters/repeater_weekend'
  autoload :RepeaterWeekday, 'chronic/repeaters/repeater_weekday'
  autoload :RepeaterDay, 'chronic/repeaters/repeater_day'
  autoload :RepeaterDayName, 'chronic/repeaters/repeater_day_name'
  autoload :RepeaterDayPortion, 'chronic/repeaters/repeater_day_portion'
  autoload :RepeaterHour, 'chronic/repeaters/repeater_hour'
  autoload :RepeaterMinute, 'chronic/repeaters/repeater_minute'
  autoload :RepeaterSecond, 'chronic/repeaters/repeater_second'
  autoload :RepeaterTime, 'chronic/repeaters/repeater_time'

  # Returns a Hash of default configuration options.
  DEFAULT_OPTIONS = {
    :context => :future,
    :now => nil,
    :guess => true,
    :ambiguous_time_range => 6,
    :endian_precedence    => [:middle, :little],
    :ambiguous_year_future_bias => 50
  }

  class << self

    # Parses a string containing a natural language date or time.
    #
    # If the parser can find a date or time, either a Time or Chronic::Span
    # will be returned (depending on the value of `:guess`). If no
    # date or time can be found, `nil` will be returned.
    #
    # text - The String text to parse.
    # opts - An optional Hash of configuration options:
    #        :context - If your string represents a birthday, you can set
    #                   this value to :past and if an ambiguous string is
    #                   given, it will assume it is in the past.
    #        :now - Time, all computations will be based off of time
    #               instead of Time.now.
    #        :guess - By default the parser will guess a single point in time
    #                 for the given date or time. If you'd rather have the
    #                 entire time span returned, set this to false
    #                 and a Chronic::Span will be returned.
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
    #
    # Returns a new Time object, or Chronic::Span if :guess option is false.
    def parse(text, opts={})
      options = DEFAULT_OPTIONS.merge opts

      # ensure the specified options are valid
      (opts.keys - DEFAULT_OPTIONS.keys).each do |key|
        raise ArgumentError, "#{key} is not a valid option key."
      end

      unless [:past, :future, :none].include?(options[:context])
        raise ArgumentError, "Invalid context, :past/:future only"
      end

      options[:text] = text
      Chronic.now = options[:now] || Chronic.time_class.now

      # tokenize words
      tokens = tokenize(text, options)

      if Chronic.debug
        puts "+#{'-' * 51}\n| #{tokens}\n+#{'-' * 51}"
      end

      span = tokens_to_span(tokens, options)

      if span
        options[:guess] ? guess(span) : span
      end
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
      text.gsub!(/\./, ':')
      text.gsub!(/['"]/, '')
      text.gsub!(/,/, ' ')
      text.gsub!(/^second /, '2nd ')
      text.gsub!(/\bsecond (of|day|month|hour|minute|second)\b/, '2nd \1')
      text = Numerizer.numerize(text)
      text.gsub!(/\-(\d{2}:?\d{2})\b/, 'tzminus\1')
      text.gsub!(/([\/\-\,\@])/) { ' ' + $1 + ' ' }
      text.gsub!(/(?:^|\s)0(\d+:\d+\s*pm?\b)/, ' \1')
      text.gsub!(/\btoday\b/, 'this day')
      text.gsub!(/\btomm?orr?ow\b/, 'next day')
      text.gsub!(/\byesterday\b/, 'last day')
      text.gsub!(/\bnoon\b/, '12:00pm')
      text.gsub!(/\bmidnight\b/, '24:00')
      text.gsub!(/\bnow\b/, 'this second')
      text.gsub!(/\b(?:ago|before(?: now)?)\b/, 'past')
      text.gsub!(/\bthis (?:last|past)\b/, 'last')
      text.gsub!(/\b(?:in|during) the (morning)\b/, '\1')
      text.gsub!(/\b(?:in the|during the|at) (afternoon|evening|night)\b/, '\1')
      text.gsub!(/\btonight\b/, 'this night')
      text.gsub!(/\b\d+:?\d*[ap]\b/,'\0m')
      text.gsub!(/(\d)([ap]m|oclock)\b/, '\1 \2')
      text.gsub!(/\b(hence|after|from)\b/, 'future')
      text.gsub!(/^\s?an? /i, '1 ')
      text.gsub!(/\b(\d{4}):(\d{2}):(\d{2})\b/, '\1 / \2 / \3') # DTOriginal
      text
    end

    # Convert number words to numbers (three => 3, fourth => 4th).
    #
    # text - The String to convert.
    #
    # Returns a new String with words converted to numbers.
    def numericize_numbers(text)
      warn "Chronic.numericize_numbers will be deprecated in version 0.7.0. Please use Chronic::Numerizer.numerize instead"
      Numerizer.numerize(text)
    end

    # Guess a specific time within the given span.
    #
    # span - The Chronic::Span object to calcuate a guess from.
    #
    # Returns a new Time object.
    def guess(span)
      if span.width > 1
        span.begin + (span.width / 2)
      else
        span.begin
      end
    end

    # List of Handler definitions. See #parse for a list of options this
    # method accepts.
    #
    # options - An optional Hash of configuration options:
    #           :endian_precedence -
    #
    # Returns A Hash of Handler definitions.
    def definitions(options={})
      options[:endian_precedence] ||= [:middle, :little]

      @definitions ||= {
        :time => [
          Handler.new([:repeater_time, :repeater_day_portion?], nil)
        ],

        :date => [
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :repeater_time, :separator_slash_or_dash?, :time_zone, :scalar_year], :handle_generic),
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day], :handle_rdn_rmn_sd),
          Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :scalar_year], :handle_rdn_rmn_sd_sy),
          Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day], :handle_rdn_rmn_od),
          Handler.new([:scalar_year, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar_day, :repeater_time, :time_zone], :handle_generic),
          Handler.new([:repeater_month_name, :scalar_day, :scalar_year], :handle_rmn_sd_sy),
          Handler.new([:repeater_month_name, :ordinal_day, :scalar_year], :handle_rmn_od_sy),
          Handler.new([:repeater_month_name, :scalar_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_sd_sy),
          Handler.new([:repeater_month_name, :ordinal_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_od_sy),
          Handler.new([:repeater_month_name, :scalar_day, :separator_at?, 'time?'], :handle_rmn_sd),
          Handler.new([:repeater_time, :repeater_day_portion?, :separator_on?, :repeater_month_name, :scalar_day], :handle_rmn_sd_on),
          Handler.new([:repeater_month_name, :ordinal_day, :separator_at?, 'time?'], :handle_rmn_od),
          Handler.new([:ordinal_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_od_rmn_sy),
          Handler.new([:ordinal_day, :repeater_month_name, :separator_at?, 'time?'], :handle_od_rmn),
          Handler.new([:ordinal_day, :grabber?, :repeater_month, :separator_at?, 'time?'], :handle_od_rm),
          Handler.new([:scalar_year, :repeater_month_name, :ordinal_day], :handle_sy_rmn_od),
          Handler.new([:repeater_time, :repeater_day_portion?, :separator_on?, :repeater_month_name, :ordinal_day], :handle_rmn_od_on),
          Handler.new([:repeater_month_name, :scalar_year], :handle_rmn_sy),
          Handler.new([:scalar_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_sd_rmn_sy),
          Handler.new([:scalar_day, :repeater_month_name, :separator_at?, 'time?'], :handle_sd_rmn),
          Handler.new([:scalar_year, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar_day, :separator_at?, 'time?'], :handle_sy_sm_sd),
          Handler.new([:scalar_month, :separator_slash_or_dash, :scalar_year], :handle_sm_sy),
          Handler.new([:scalar_day, :separator_slash_or_dash, :repeater_month_name, :separator_slash_or_dash, :scalar_year, :repeater_time?], :handle_sm_rmn_sy),
          Handler.new([:scalar_year, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar?, :time_zone], :handle_generic),
          # Handler.new([:scalar_year, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :time_zone], :handle_generic)

        ],

        # tonight at 7pm
        :anchor => [
          Handler.new([:separator_on?, :grabber?, :repeater, :separator_at?, :repeater?, :repeater?], :handle_r),
          Handler.new([:grabber?, :repeater, :repeater, :separator?, :repeater?, :repeater?], :handle_r),
          Handler.new([:repeater, :grabber, :repeater], :handle_r_g_r)
        ],

        # 3 weeks from now, in 2 months
        :arrow => [
          Handler.new([:scalar, :repeater, :pointer], :handle_s_r_p),
          Handler.new([:pointer, :scalar, :repeater], :handle_p_s_r),
          Handler.new([:scalar, :repeater, :pointer, :separator_at?, 'anchor'], :handle_s_r_p_a)
        ],

        # 3rd week in march
        :narrow => [
          Handler.new([:ordinal, :repeater, :separator_in, :repeater], :handle_o_r_s_r),
          Handler.new([:ordinal, :repeater, :grabber, :repeater], :handle_o_r_g_r)
        ]
      }

      endians = [
        Handler.new([:scalar_month, :separator_slash_or_dash, :scalar_day, :separator_slash_or_dash, :scalar_year, :separator_at?, 'time?'], :handle_sm_sd_sy),
        Handler.new([:scalar_month, :separator_slash_or_dash, :scalar_day, :separator_at?, 'time?'], :handle_sm_sd),
        Handler.new([:scalar_day, :separator_slash_or_dash, :scalar_month, :separator_at?, 'time?'], :handle_sd_sm),
        Handler.new([:scalar_day, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar_year, :separator_at?, 'time?'], :handle_sd_sm_sy)
      ]

      case endian = Array(options[:endian_precedence]).first
      when :little
        @definitions[:endian] = endians.reverse
      when :middle
        @definitions[:endian] = endians
      else
        raise ArgumentError, "Unknown endian option '#{endian}'"
      end

      @definitions
    end

    # Construct a new time object determining possible month overflows
    # and leap years.
    #
    # year   - Integer year.
    # month  - Integer month.
    # day    - Integer day.
    # hour   - Integer hour.
    # minute - Integer minute.
    # second - Integer second.
    #
    # Returns a new Time object constructed from these params.
    def construct(year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
      if second >= 60
        minute += second / 60
        second = second % 60
      end

      if minute >= 60
        hour += minute / 60
        minute = minute % 60
      end

      if hour >= 24
        day += hour / 24
        hour = hour % 24
      end

      # determine if there is a day overflow. this is complicated by our crappy calendar
      # system (non-constant number of days per month)
      day <= 56 || raise("day must be no more than 56 (makes month resolution easier)")
      if day > 28
        # no month ever has fewer than 28 days, so only do this if necessary
        leap_year_month_days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        common_year_month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        days_this_month = Date.leap?(year) ? leap_year_month_days[month - 1] : common_year_month_days[month - 1]
        if day > days_this_month
          month += day / days_this_month
          day = day % days_this_month
        end
      end

      if month > 12
        if month % 12 == 0
          year += (month - 12) / 12
          month = 12
        else
          year += month / 12
          month = month % 12
        end
      end

      Chronic.time_class.local(year, month, day, hour, minute, second)
    end

    private

    def tokenize(text, options)
      text = pre_normalize(text)
      tokens = text.split(' ').map { |word| Token.new(word) }
      [Repeater, Grabber, Pointer, Scalar, Ordinal, Separator, TimeZone].each do |tok|
        tok.scan(tokens, options)
      end
      tokens.select { |token| token.tagged? }
    end

    def tokens_to_span(tokens, options)
      definitions = definitions(options)

      (definitions[:endian] + definitions[:date]).each do |handler|
        if handler.match(tokens, definitions)
          good_tokens = tokens.select { |o| !o.get_tag Separator }
          return handler.invoke(:date, good_tokens, options)
        end
      end

      definitions[:anchor].each do |handler|
        if handler.match(tokens, definitions)
          good_tokens = tokens.select { |o| !o.get_tag Separator }
          return handler.invoke(:anchor, good_tokens, options)
        end
      end

      definitions[:arrow].each do |handler|
        if handler.match(tokens, definitions)
          good_tokens = tokens.reject { |o| o.get_tag(SeparatorAt) || o.get_tag(SeparatorSlashOrDash) || o.get_tag(SeparatorComma) }
          return handler.invoke(:arrow, good_tokens, options)
        end
      end

      definitions[:narrow].each do |handler|
        if handler.match(tokens, definitions)
          return handler.invoke(:narrow, tokens, options)
        end
      end

      puts "-none" if Chronic.debug
      return nil
    end

  end

  # Internal exception
  class ChronicPain < Exception
  end

end