module Chronic
  class Pointer < Tag

    # Scan an Array of Token objects and apply any necessary Pointer
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
        'past' => :past,
        /^future|in$/i => :future,
      }
    end

    def to_s
      'pointer-' << @type.to_s
    end
  end
end
