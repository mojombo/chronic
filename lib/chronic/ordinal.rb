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
      tokens.each do |token|
        if t = scan_for_ordinals(token) then token.tag(t) end
        if t = scan_for_days(token) then token.tag(t) end
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Ordinal object.
    def self.scan_for_ordinals(token)
      Ordinal.new($1.to_i) if token.word =~ /^(\d*)(st|nd|rd|th)$/
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Ordinal object.
    def self.scan_for_days(token)
      if token.word =~ /^(\d*)(st|nd|rd|th)$/
        unless $1.to_i > 31 || $1.to_i < 1
          OrdinalDay.new(token.word.to_i)
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

end
