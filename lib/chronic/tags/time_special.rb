module Chronic
  class TimeSpecial < Tag

    # Scan an Array of Token objects and apply any necessary TimeSpecial
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
        'now'                 => :now,
        'morning'             => :morning,
        'noon'                => :noon,
        'afternoon'           => :afternoon,
        'evening'             => :evening,
        /^(to)?(night|nite)$/ => :night,
        'midnight'            => :midnight
      }
    end

    def to_s
      'timespecial-' << @type.to_s
    end
  end

end
