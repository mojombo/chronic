module Chronic
  class DayPortion < Tag

    # Scan an Array of Token objects and apply any necessary DayPortion
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for(token, self, patterns, options)
      end
    end

    def self.patterns
      @@patterns ||= {
        /^ams?$/i => :am,
        /^pms?$/i => :pm,
        'a.m.'    => :am,
        'p.m.'    => :pm,
        'a'       => :am,
        'p'       => :pm
      }
    end

    def to_s
      'dayportion-' << @type.to_s
    end
  end

end
