module Chronic
  class Pointer < Tag

    # Scan an Array of {Token}s and apply any necessary Pointer tags to
    # each token
    #
    # @param [Array<Token>] tokens Array of tokens to scan
    # @param [Hash] options Options specified in {Chronic.parse}
    # @return [Array] list of tokens
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_all(token) then token.tag(t) end
      end
    end

    # @param [Token] token
    # @return [Pointer, nil]
    def self.scan_for_all(token)
      scan_for token, self,
      {
        /\bpast\b/ => :past,
        /\b(?:future|in)\b/ => :future,
      }
    end

    def to_s
      'pointer-' << @type.to_s
    end
  end
end
