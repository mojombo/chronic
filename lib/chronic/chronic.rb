module Chronic

  DEFAULT_OPTIONS = {
    :context => :future,
    :now     => Chronic.time_class.now,
    :guess   => true,
    :ambiguous_time_range => 6,
    :endian_precedence    => [:middle, :little],
    :ambiguous_year_future_bias => 50
  }

  class << self

    # Parses a string containing a natural language date or time. If the parser
    # can find a date or time, either a Time or Chronic::Span will be returned
    # (depending on the value of <tt>:guess</tt>). If no date or time can be found,
    # +nil+ will be returned.
    #
    # Options are:
    #
    # [<tt>:context</tt>]
    #     <tt>:past</tt> or <tt>:future</tt> (defaults to <tt>:future</tt>)
    #
    #     If your string represents a birthday, you can set <tt>:context</tt> to <tt>:past</tt>
    #     and if an ambiguous string is given, it will assume it is in the
    #     past. Specify <tt>:future</tt> or omit to set a future context.
    #
    # [<tt>:now</tt>]
    #     Time (defaults to Time.now)
    #
    #     By setting <tt>:now</tt> to a Time, all computations will be based off
    #     of that time instead of Time.now. If set to nil, Chronic will use Time.now.
    #
    # [<tt>:guess</tt>]
    #     +true+ or +false+ (defaults to +true+)
    #
    #     By default, the parser will guess a single point in time for the
    #     given date or time. If you'd rather have the entire time span returned,
    #     set <tt>:guess</tt> to +false+ and a Chronic::Span will be returned.
    #
    # [<tt>:ambiguous_time_range</tt>]
    #     Integer or <tt>:none</tt> (defaults to <tt>6</tt> (6am-6pm))
    #
    #     If an Integer is given, ambiguous times (like 5:00) will be
    #     assumed to be within the range of that time in the AM to that time
    #     in the PM. For example, if you set it to <tt>7</tt>, then the parser will
    #     look for the time between 7am and 7pm. In the case of 5:00, it would
    #     assume that means 5:00pm. If <tt>:none</tt> is given, no assumption
    #     will be made, and the first matching instance of that time will
    #     be used.
    #
    # [<tt>:endian_precedence</tt>]
    #     Array (defaults to <tt>[:middle, :little]</tt>)
    #
    #     By default, Chronic will parse "03/04/2011" as the fourth day
    #     of the third month. Alternatively you can tell Chronic to parse
    #     this as the third day of the fourth month by altering the
    #     <tt>:endian_precedence</tt> to <tt>[:little, :middle]</tt>.
    def parse(text, specified_options = {})
      @text = text
      options = DEFAULT_OPTIONS.merge specified_options

      # ensure the specified options are valid
      specified_options.keys.each do |key|
        DEFAULT_OPTIONS.keys.include?(key) || raise(InvalidArgumentException, "#{key} is not a valid option key.")
      end
      [:past, :future, :none].include?(options[:context]) || raise(InvalidArgumentException, "Invalid value ':#{options[:context]}' for :context specified. Valid values are :past and :future.")

      # store now for later =)
      @now = options[:now]

      # put the text into a normal format to ease scanning
      text = pre_normalize(text)

      # tokenize words
      @tokens = tokenize(text, options)

      if Chronic.debug
        puts "+---------------------------------------------------"
        puts "| " + @tokens.to_s
        puts "+---------------------------------------------------"
      end

      span = tokens_to_span(@tokens, options)

      if options[:guess]
        guess span
      else
        span
      end
    end

    # Clean up the specified input text by stripping unwanted characters,
    # converting idioms to their canonical form, converting number words
    # to numbers (three => 3), and converting ordinal words to numeric
    # ordinals (third => 3rd)
    def pre_normalize(text) #:nodoc:
      normalized_text = text.to_s.downcase
      normalized_text.gsub!(/['"\.,]/, '')
      normalized_text = numericize_numbers(normalized_text)
      normalized_text.gsub!(/ \-(\d{4})\b/, ' tzminus\1')
      normalized_text.gsub!(/([\/\-\,\@])/) { ' ' + $1 + ' ' }
      normalized_text.gsub!(/\b0(\d+:\d+\s*pm?\b)/, '\1')
      normalized_text.gsub!(/\btoday\b/, 'this day')
      normalized_text.gsub!(/\btomm?orr?ow\b/, 'next day')
      normalized_text.gsub!(/\byesterday\b/, 'last day')
      normalized_text.gsub!(/\bnoon\b/, '12:00')
      normalized_text.gsub!(/\bmidnight\b/, '24:00')
      normalized_text.gsub!(/\bbefore now\b/, 'past')
      normalized_text.gsub!(/\bnow\b/, 'this second')
      normalized_text.gsub!(/\b(ago|before)\b/, 'past')
      normalized_text.gsub!(/\bthis past\b/, 'last')
      normalized_text.gsub!(/\bthis last\b/, 'last')
      normalized_text.gsub!(/\b(?:in|during) the (morning)\b/, '\1')
      normalized_text.gsub!(/\b(?:in the|during the|at) (afternoon|evening|night)\b/, '\1')
      normalized_text.gsub!(/\btonight\b/, 'this night')
      normalized_text.gsub!(/\b\d+:?\d*[ap]\b/,'\0m')
      normalized_text.gsub!(/(\d)([ap]m|oclock)\b/, '\1 \2')
      normalized_text.gsub!(/\b(hence|after|from)\b/, 'future')
      normalized_text = numericize_ordinals(normalized_text)
    end

    # Convert number words to numbers (three => 3)
    def numericize_numbers(text) #:nodoc:
      Numerizer.numerize(text)
    end

    # Convert ordinal words to numeric ordinals (third => 3rd)
    def numericize_ordinals(text) #:nodoc:
      text
    end

    def tokenize(text, options) #:nodoc:
      tokens = text.split(' ').map { |word| Token.new(word) }
      [Repeater, Grabber, Pointer, Scalar, Ordinal, Separator, TimeZone].each do |tok|
        tokens = tok.scan(tokens, options)
      end
      tokens.delete_if { |token| !token.tagged? }
    end

    # Guess a specific time within the given span
    def guess(span) #:nodoc:
      return nil if span.nil?
      if span.width > 1
        span.begin + (span.width / 2)
      else
        span.begin
      end
    end
  end

  # Internal exception
  class ChronicPain < Exception #:nodoc:

  end

  # This exception is raised if an invalid argument is provided to
  # any of Chronic's methods
  class InvalidArgumentException < Exception

  end
end
