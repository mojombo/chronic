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
        if t = scan_for_plus(token) then token.tag(t); next end
        if t = scan_for_minus(token) then token.tag(t); next end
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SignPlus object.
    def self.scan_for_plus(token)
      scan_for token, SignPlus, { /^\+$/ => :plus }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SignMinus object.
    def self.scan_for_minus(token)
      scan_for token, SignMinus, { /^-$/ => :minus }
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
