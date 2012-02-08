module Chronic
  class TimeZone < Tag

    # Scan an Array of Token objects and apply any necessary TimeZone
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_all(token) then token.tag(t); next end
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Pointer object.
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
