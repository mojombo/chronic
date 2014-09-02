require 'chronic/dictionary'
require 'chronic/handlers'

module Chronic
  class Parser
    include Handlers

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
      locale.pre_normalize(text)
    end

    def locale
      options[:locale] || Chronic::Locale.default
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

      puts '-none' if Chronic.debug
      return nil
    end
  end
end
