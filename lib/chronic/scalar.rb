module Chronic

  class Scalar < Tag #:nodoc:
    def self.scan(tokens)
      # for each token
      tokens.each_index do |i|
        if t = self.scan_for_scalars(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
        if t = self.scan_for_days(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
        if t = self.scan_for_months(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
        if t = self.scan_for_years(tokens[i], tokens[i + 1]) then tokens[i].tag(t) end
      end
      tokens
    end
  
    def self.scan_for_scalars(token, post_token)
      if token.word =~ /^\d*$/
        unless post_token && %w{am pm morning afternoon evening night}.include?(post_token)
          return Scalar.new(token.word.to_i)
        end
      end
      return nil
    end
    
    def self.scan_for_days(token, post_token)
      if token.word =~ /^\d\d?$/
        unless token.word.to_i > 31 || (post_token && %w{am pm morning afternoon evening night}.include?(post_token))
          return ScalarDay.new(token.word.to_i)
        end
      end
      return nil
    end
    
    def self.scan_for_months(token, post_token)
      if token.word =~ /^\d\d?$/
        unless token.word.to_i > 12 || (post_token && %w{am pm morning afternoon evening night}.include?(post_token))
          return ScalarMonth.new(token.word.to_i)
        end
      end
      return nil
    end
    
    def self.scan_for_years(token, post_token)
      if token.word =~ /^([1-9]\d)?\d\d?$/
        unless post_token && %w{am pm morning afternoon evening night}.include?(post_token)
          return ScalarYear.new(token.word.to_i)
        end
      end
      return nil
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