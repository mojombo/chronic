module Chronic
  class Ordinal < Tag

    # Scan an Array of Token objects and apply any necessary Ordinal
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each_index do |i|
        if tokens[i].word =~ /^\d+$/ and tokens[i + 1] and tokens[i + 1].word =~ /^st|nd|rd|th|\.$/
          width = tokens[i].word.length
          ordinal = tokens[i].word.to_i
          tokens[i].tag(Ordinal.new(ordinal, width))
          tokens[i].tag(OrdinalDay.new(ordinal, width)) if Chronic::Date::could_be_day?(ordinal, width)
          tokens[i].tag(OrdinalMonth.new(ordinal, width)) if Chronic::Date::could_be_month?(ordinal, width)
          if Chronic::Date::could_be_year?(ordinal, width)
            year = Chronic::Date::make_year(ordinal, options[:ambiguous_year_future_bias])
            tokens[i].tag(OrdinalYear.new(year.to_i, width))
          end
        elsif tokens[i].word =~ /^second$/
          tokens[i].tag(Ordinal.new(2, 1))
        end
      end
    end

    def to_s
      'ordinal'
    end
  end

  class OrdinalDay < Ordinal #:nodoc:
    def to_s
      super << '-day-' << @type.to_s
    end
  end

  class OrdinalMonth < Ordinal #:nodoc:
    def to_s
      super << '-month-' << @type.to_s
    end
  end

  class OrdinalYear < Ordinal #:nodoc:
    def to_s
      super << '-year-' << @type.to_s
    end
  end

end
