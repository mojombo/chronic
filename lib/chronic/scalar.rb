module Chronic

  class Scalar < Tag #:nodoc:
    DAY_PORTIONS = %w( am pm morning afternoon evening night )

    def self.scan(tokens, options)
      # for each token
      tokens.each_index do |i|
        if t = self.scan_for_scalars(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
        if t = self.scan_for_days(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
        if t = self.scan_for_months(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
        if t = self.scan_for_years(tokens[i], tokens[i + 1], options) then tokens[i].tag(t) end
      end
    end

    def self.scan_for_scalars(token, post_token)
      if token.word =~ /^\d*$/
        unless post_token && DAY_PORTIONS.include?(post_token.word)
          return Scalar.new(token.word.to_i)
        end
      end
    end

    def self.scan_for_days(token, post_token)
      if token.word =~ /^\d\d?$/
        toi = token.word.to_i
        unless toi > 31 || toi < 1 || (post_token && DAY_PORTIONS.include?(post_token.word))
          return ScalarDay.new(toi)
        end
      end
    end

    def self.scan_for_months(token, post_token)
      if token.word =~ /^\d\d?$/
        toi = token.word.to_i
        unless toi > 12 || toi < 1 || (post_token && DAY_PORTIONS.include?(post_token.word))
          return ScalarMonth.new(toi)
        end
      end
    end

    def self.scan_for_years(token, post_token, options)
      if token.word =~ /^([1-9]\d)?\d\d?$/
        unless post_token && DAY_PORTIONS.include?(post_token.word)
          year = make_year(token.word.to_i, options[:ambiguous_year_future_bias])
          return ScalarYear.new(year.to_i)
        end
      end
    end

    # Build a year from a 2 digit suffix
    def self.make_year(year, bias)
      string = year.to_s
      return string if string.size > 2
      string.insert(0, '0') if string.size == 1
      start_year = Time.now.year - bias
      suffix = start_year.to_s[-2, 2].to_i
      which = year <= suffix ? start_year + 100 : start_year
      which.to_s[0, 2] + string
    end

    def to_s
      'scalar'
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
