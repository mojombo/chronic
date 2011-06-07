module Chronic
  class Grabber < Tag

    # Scan an Array of {Token}s and apply any necessary Grabber tags to
    # each token
    #
    # @param [Array<Token>] tokens Array of tokens to scan
    # @param [Hash] options Options specified in {Chronic.parse}
    # @return [Array] list of tokens
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_all(token) then token.tag(t); next end
      end
    end

    # @param [Token] token
    # @return [Grabber, nil]
    def self.scan_for_all(token)
      scan_for token, self,
      {
        /last/ => :last,
        /this/ => :this,
        /next/ => :next
      }
    end

    def to_s
      'grabber-' << @type.to_s
    end
  end
end