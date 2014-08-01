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
        token.tag scan_for(token, SeparatorComma, { ','.to_sym => :comma })
        token.tag scan_for(token, SeparatorDot, { '.'.to_sym => :dot })
        token.tag scan_for(token, SeparatorColon, { ':'.to_sym => :colon })
        token.tag scan_for(token, SeparatorSpace, { ' '.to_sym => :space })
        token.tag scan_for(token, SeparatorSlash, { '/'.to_sym => :slash })
        token.tag scan_for(token, SeparatorDash, { :- => :dash })
        token.tag scan_for(token, SeparatorAt, { /^(at|@)$/i => :at })
        token.tag scan_for(token, SeparatorIn, { 'in' => :in })
        token.tag scan_for(token, SeparatorOn, { 'on' => :on })
        token.tag scan_for(token, SeparatorAnd, { 'and' => :and })
        token.tag scan_for(token, SeparatorT, { :T => :T })
        token.tag scan_for(token, SeparatorW, { :W => :W })
        token.tag scan_for_quote(token)
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorQuote object.
    def self.scan_for_quote(token)
      scan_for token, SeparatorQuote,
      {
        "'".to_sym => :single_quote,
        '"'.to_sym => :double_quote
      }
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
