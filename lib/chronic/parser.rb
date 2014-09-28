require 'chronic/dictionary'

module Chronic
  class Parser

    # Hash of default configuration options.
    DEFAULT_OPTIONS = {
      :context => :future,
      :now => nil,
      :hours24 => nil,
      :week_start => :sunday,
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
    #        :week_start - By default, the parser assesses weeks start on
    #                  sunday but you can change this value to :monday if
    #                  needed.
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
      validate_options!(options)
      @options = DEFAULT_OPTIONS.merge(options)
      @now = options[:now] || Chronic.time_class.now
    end

    # Parse "text" with the given options
    # Returns either a Time or Chronic::Span, depending on the value of options[:guess]
    def parse(text)
      text = pre_proccess(text)
      text = pre_normalize(text)
      puts text.inspect if Chronic.debug

      tokens = Tokenizer::tokenize(' ' + text + ' ')
      tag(tokens, options)

      puts "+#{'-' * 51}\n| #{tokens}\n+#{'-' * 51}" if Chronic.debug

      token_group = TokenGroup.new(tokens, definitions(options), @now, options)
      span = token_group.to_span

      guess(span, options[:guess]) if span
    end

    # Replace any whitespace characters to single space
    def pre_proccess(text)
      text.to_s.strip.gsub(/[[:space:]]+/, ' ').gsub(/\s{2,}/, ' ')
    end

    # Clean up the specified text ready for parsing.
    #
    # Clean up the string, convert number words to numbers
    # (three => 3), and convert ordinal words to numeric
    # ordinals (third => 3rd)
    #
    # text - The String text to normalize.
    #
    # Returns a new String ready for Chronic to parse.
    def pre_normalize(text)
      text = Numerizer.numerize(text)
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
      SpanDictionary.new(options).definitions
    end

    private


    def validate_options!(options)
      given = options.keys.map(&:to_s).sort
      allowed = DEFAULT_OPTIONS.keys.map(&:to_s).sort
      non_permitted = given - allowed
      raise ArgumentError, "Unsupported option(s): #{non_permitted.join(', ')}" if non_permitted.any?
    end

    def tag(tokens, options)
      [DayName, MonthName, SeasonName, DaySpecial, TimeSpecial, DayPortion, Grabber, Pointer, Rational, Keyword, Separator, Scalar, Ordinal, Sign, Unit, TimeZoneTag].each do |tok|
        tok.scan(tokens, options)
      end
      previous = nil
      tokens.select! do |token|
        if token.tagged?
          if !previous or !token.tags.first.kind_of?(Separator) or token.tags.first.class != previous.class
            previous = token.tags.first
            true
          else
            false
          end
        else
          false
        end
      end
    end

  end
end
