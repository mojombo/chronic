module Chronic
  class TimeZoneTag < Tag

    # Scan an Array of Token objects and apply any necessary TimeZoneTag
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each_index do |i|
        token = tokens[i]
        token.tag scan_for(token, TimeZoneGeneric, patterns)
        token.tag TimeZoneAbbreviation.new(token.word, nil, options) if TimeZone::is_valid_abbr?(token.word)
      end
    end

    def self.patterns
      @@patterns ||= {
        :UTC => 0,
        :Z   => 0
      }
    end

    def to_s
      'timezone'
    end

  end

  class TimeZoneGeneric < TimeZoneTag #:nodoc:
    def to_s
      super + '-generic-' + @type.to_s
    end
  end

  class TimeZoneAbbreviation < TimeZoneTag #:nodoc:
    def to_s
      super + '-abbr-' + @type.to_s
    end
  end

  class TimeZoneName < TimeZoneTag #:nodoc:
    def to_s
      super + '-name-' + @type.to_s
    end
  end

  class TimeZoneTZ < TimeZoneTag #:nodoc:
    def to_s
      super + '-tz-' + @type.to_s
    end
  end

end
