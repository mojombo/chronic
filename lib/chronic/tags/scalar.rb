module Chronic
  class Scalar < Tag
    DAY_PORTIONS = %w( am pm morning afternoon evening night )

    # Scan an Array of Token objects and apply any necessary Scalar
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each_index do |i|
        if is_scalar?(tokens, i)
            token = tokens[i]
            post_token = tokens[i + 1]
            width = token.word.length
            scalar = token.word.to_i
            token.tag(Scalar.new(scalar, width))
            token.tag(ScalarWide.new(token.word, width)) if width == 4
            token.tag(ScalarSubsecond.new(scalar, width)) if Chronic::Time::could_be_subsecond?(scalar, width)
            token.tag(ScalarSecond.new(scalar, width)) if Chronic::Time::could_be_second?(scalar, width)
            token.tag(ScalarMinute.new(scalar, width)) if Chronic::Time::could_be_minute?(scalar, width)
            token.tag(ScalarHour.new(scalar, width)) if Chronic::Time::could_be_hour?(scalar, width, options[:hours24] == false)
            unless post_token and DAY_PORTIONS.include?(post_token.word)
              token.tag(ScalarDay.new(scalar, width)) if Chronic::Date::could_be_day?(scalar, width)
              token.tag(ScalarMonth.new(scalar, width)) if Chronic::Date::could_be_month?(scalar, width)
              token.tag(ScalarFullYear.new(scalar, width)) if width == 4 and Chronic::Date::could_be_year?(scalar, width)
              if Chronic::Date::could_be_year?(scalar, width)
                year = Chronic::Date::make_year(scalar, options[:ambiguous_year_future_bias])
                token.tag(ScalarYear.new(year.to_i, width))
              end
          end
        end
      end
    end

    def self.is_scalar?(tokens, i)
      tokens[i].word =~ /^\d+$/ and (not tokens[i + 1] or not tokens[i + 1].word =~ /^st|nd|rd|th$/)
    end

    def to_s
      'scalar'
    end
  end

  class ScalarWide < Scalar #:nodoc:
    def to_s
      super << '-wide-' << @type.to_s
    end
  end

  class ScalarSubsecond < Scalar #:nodoc:
    def to_s
      super << '-subsecond-' << @type.to_s
    end
  end

  class ScalarSecond < Scalar #:nodoc:
    def to_s
      super << '-second-' << @type.to_s
    end
  end

  class ScalarMinute < Scalar #:nodoc:
    def to_s
      super << '-minute-' << @type.to_s
    end
  end

  class ScalarHour < Scalar #:nodoc:
    def to_s
      super << '-hour-' << @type.to_s
    end
  end

  class ScalarDay < Scalar #:nodoc:
    def to_s
      super << '-day-' << @type.to_s
    end
  end

  class ScalarMonth < Scalar #:nodoc:
    def to_s
      super << '-month-' << @type.to_s
    end
  end

  class ScalarYear < Scalar #:nodoc:
    def to_s
      super << '-year-' << @type.to_s
    end
  end

  class ScalarFullYear < Scalar #:nodoc:
    def to_s
      super << '-fullyear-' << @type.to_s
    end
  end

end
