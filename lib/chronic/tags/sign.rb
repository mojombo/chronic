module Chronic
  class Sign < Tag

    # Scan an Array of Token objects and apply any necessary Sign
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for(token, SignPlus, { :+ => :plus })
        token.tag scan_for(token, SignMinus, { :- => :minus })
      end
    end

    def to_s
      'sign'
    end
  end

  class SignPlus < Sign #:nodoc:
    def to_s
      super << '-plus'
    end
  end

  class SignMinus < Sign #:nodoc:
    def to_s
      super << '-minus'
    end
  end

end
