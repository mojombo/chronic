module Chronic
  class TimeZone < Tag

    # Scan an Array of {Token}s and apply any necessary TimeZone tags to
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
    # @return [TimeZone, nil]
    def self.scan_for_all(token)
      scan_for token, self,
      {
        /[PMCE][DS]T|UTC/i => :tz,
        /(tzminus)?\d{2}:?\d{2}/ => :tz
      }
    end

    def to_s
      'timezone'
    end
  end
end
