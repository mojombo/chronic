module Chronic
  class Keyword < Tag

    # Scan an Array of Token objects and apply any necessary Keyword
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for(token, KeywordAt,  { /^(at|@)$/i => :at  })
        token.tag scan_for(token, KeywordIn,  { 'in'        => :in  })
        token.tag scan_for(token, KeywordOn,  { 'on'        => :on  })
        token.tag scan_for(token, KeywordAnd, { 'and'       => :and })
        token.tag scan_for(token, KeywordTo,  { 'to'        => :to  })
      end
    end

    def to_s
      'keyword'
    end
  end

  class KeywordAt < Keyword #:nodoc:
    def to_s
      super << '-at'
    end
  end

  class KeywordIn < Keyword #:nodoc:
    def to_s
      super << '-in'
    end
  end

  class KeywordOn < Keyword #:nodoc:
    def to_s
      super << '-on'
    end
  end

  class KeywordAnd < Keyword #:nodoc:
    def to_s
      super << '-and'
    end
  end

  class KeywordTo < Keyword #:nodoc:
    def to_s
      super << '-to'
    end
  end

end
