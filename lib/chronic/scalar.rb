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
        token = tokens[i]
        post_token = tokens[i + 1]
        if token.word =~ /^\d+$/
            scalar = token.word.to_i
            token.tag(Scalar.new(scalar))
            token.tag(ScalarSubsecond.new(scalar)) if Chronic::Time::could_be_subsecond?(scalar)
            token.tag(ScalarSecond.new(scalar)) if Chronic::Time::could_be_second?(scalar)
            token.tag(ScalarMinute.new(scalar)) if Chronic::Time::could_be_minute?(scalar)
            token.tag(ScalarHour.new(scalar)) if Chronic::Time::could_be_hour?(scalar)
            unless post_token and DAY_PORTIONS.include?(post_token.word)
              token.tag(ScalarDay.new(scalar)) if Chronic::Date::could_be_day?(scalar)
              token.tag(ScalarMonth.new(scalar)) if Chronic::Date::could_be_month?(scalar)
              if Chronic::Date::could_be_year?(scalar)
                year = Chronic::Date::make_year(scalar, options[:ambiguous_year_future_bias])
                token.tag(ScalarYear.new(year.to_i))
              end
            end
        end
      end
    end

    def to_s
      'scalar'
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
end