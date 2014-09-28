module Chronic
  class MonthName < Tag

    # Scan an Array of Token objects and apply any necessary MonthName
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
        /^jan[:\.]?(uary)?$/i           => :january,
        /^feb[:\.]?(ruary)?$/i          => :february,
        /^mar[:\.]?(ch)?$/i             => :march,
        /^apr[:\.]?(il)?$/i             => :april,
        /^may$/i                        => :may,
        /^jun[:\.]?e?$/i                => :june,
        /^jul[:\.]?y?$/i                => :july,
        /^aug[:\.]?(ust)?$/i            => :august,
        /^sep[:\.]?(t[:\.]?|tember)?$/i => :september,
        /^oct[:\.]?(ober)?$/i           => :october,
        /^nov[:\.]?(ember)?$/i          => :november,
        /^dec[:\.]?(ember)?$/i          => :december
      }
    end

    def to_s
      'monthname-' << @type.to_s
    end
  end

end
