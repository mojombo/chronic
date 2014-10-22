module Chronic
  class Separator < Tag

    # Scan an Array of Token objects and apply any necessary Separator
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for_commas(token, options)
        token.tag scan_for_dots(token, options)
        token.tag scan_for_colon(token, options)
        token.tag scan_for_space(token, options)
        token.tag scan_for_slash(token, options)
        token.tag scan_for_dash(token, options)
        token.tag scan_for_quote(token, options)
        token.tag scan_for_at(token, options)
        token.tag scan_for_in(token, options)
        token.tag scan_for_on(token, options)
        token.tag scan_for_and(token, options)
        token.tag scan_for_t(token, options)
        token.tag scan_for_w(token, options)
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorComma object.
    def self.scan_for_commas(token, options={})
      scan_for token, SeparatorComma, { options[:locale]['separator.comma'] => :comma }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorDot object.
    def self.scan_for_dots(token, options={})
      scan_for token, SeparatorDot, { options[:locale]['separator.dot'] => :dot }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorColon object.
    def self.scan_for_colon(token, options={})
      scan_for token, SeparatorColon, { options[:locale]['separator.colon'] => :colon }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorSpace object.
    def self.scan_for_space(token, options={})
      scan_for token, SeparatorSpace, { options[:locale]['separator.space'] => :space }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorSlash object.
    def self.scan_for_slash(token, options={})
      scan_for token, SeparatorSlash, { options[:locale]['separator.slash'] => :slash }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorDash object.
    def self.scan_for_dash(token, options={})
      scan_for token, SeparatorDash, { options[:locale]['separator.dash'] => :dash }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorQuote object.
    def self.scan_for_quote(token, options={})
      scan_for token, SeparatorQuote, options[:locale]['separator.scan_for_quote']
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorAt object.
    def self.scan_for_at(token, options={})
      scan_for token, SeparatorAt, { options[:locale]['separator.at'] => :at }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorIn object.
    def self.scan_for_in(token, options={})
      scan_for token, SeparatorIn, { options[:locale]['separator.in'] => :in }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorOn object.
    def self.scan_for_on(token, options={})
      scan_for token, SeparatorOn, { options[:locale]['separator.on'] => :on }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorAnd Object object.
    def self.scan_for_and(token, options={})
      scan_for token, SeparatorAnd, { options[:locale]['separator.and'] => :and }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorT Object object.
    def self.scan_for_t(token, options={})
      scan_for token, SeparatorT, { options[:locale]['separator.t'] => :T }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorW Object object.
    def self.scan_for_w(token, options={})
      scan_for token, SeparatorW, { options[:locale]['separator.w'] => :W }
    end

    def to_s
      'separator'
    end
  end

  class SeparatorComma < Separator #:nodoc:
    def to_s
      super << '-comma'
    end
  end

  class SeparatorDot < Separator #:nodoc:
    def to_s
      super << '-dot'
    end
  end

  class SeparatorColon < Separator #:nodoc:
    def to_s
      super << '-colon'
    end
  end

  class SeparatorSpace < Separator #:nodoc:
    def to_s
      super << '-space'
    end
  end

  class SeparatorSlash < Separator #:nodoc:
    def to_s
      super << '-slash'
    end
  end

  class SeparatorDash < Separator #:nodoc:
    def to_s
      super << '-dash'
    end
  end

  class SeparatorQuote < Separator #:nodoc:
    def to_s
      super << '-quote-' << @type.to_s
    end
  end

  class SeparatorAt < Separator #:nodoc:
    def to_s
      super << '-at'
    end
  end

  class SeparatorIn < Separator #:nodoc:
    def to_s
      super << '-in'
    end
  end

  class SeparatorOn < Separator #:nodoc:
    def to_s
      super << '-on'
    end
  end

  class SeparatorAnd < Separator #:nodoc:
    def to_s
      super << '-and'
    end
  end

  class SeparatorT < Separator #:nodoc:
    def to_s
      super << '-T'
    end
  end

  class SeparatorW < Separator #:nodoc:
    def to_s
      super << '-W'
    end
  end

end
