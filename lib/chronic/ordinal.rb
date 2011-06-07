module Chronic
  class Ordinal < Tag

    # Scan an Array of {Token}s and apply any necessary Ordinal tags to
    # each token
    #
    # @param [Array<Token>] tokens Array of tokens to scan
    # @param [Hash] options Options specified in {Chronic.parse}
    # @return [Array] list of tokens
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_ordinals(token) then token.tag(t) end
        if t = scan_for_days(token) then token.tag(t) end
      end
    end

    # @param [Token] token
    # @return [Ordinal, nil]
    def self.scan_for_ordinals(token)
      Ordinal.new($1.to_i) if token.word =~ /^(\d*)(st|nd|rd|th)$/
    end

    # @param [Token] token
    # @return [OrdinalDay, nil]
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
