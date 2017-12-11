module Chronic
  class Rational < Tag

    # Scan an Array of Token objects and apply any necessary Keyword
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for(token, RationalQuarter,  { 'quarter' => Rational(1, 4) })
        token.tag scan_for(token, RationalHalf,     { 'half'    => Rational(1, 2) })
      end
    end

    def to_s
      'rational'
    end
  end

  class RationalQuarter < Rational #:nodoc:
    def to_s
      super << '-quarter'
    end
  end

  class RationalHalf < Rational #:nodoc:
    def to_s
      super << '-half'
    end
  end

end
