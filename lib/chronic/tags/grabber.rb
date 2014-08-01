module Chronic
  class Grabber < Tag

    # Scan an Array of Tokens and apply any necessary Grabber tags to
    # each token.
    #
    # tokens  - An Array of Token objects to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of Token objects.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for(token, self, patterns, options)
      end
    end

    def self.patterns
      @@patterns ||= {
        'last' => :last,
        'this' => :this,
        'next' => :next
      }
    end

    def to_s
      'grabber-' << @type.to_s
    end
  end
end