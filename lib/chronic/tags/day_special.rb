module Chronic
  class DaySpecial < Tag

    # Scan an Array of Token objects and apply any necessary SeasonName
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
        /^yesterday$/i => :yesterday,
        /^today$/i     => :today,
        /^tomorrow$/i  => :tomorrow
      }
    end

    def to_s
      'dayspecial-' << @type.to_s
    end
  end

end
