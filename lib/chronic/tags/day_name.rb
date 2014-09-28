module Chronic
  class DayName < Tag

    # Scan an Array of Token objects and apply any necessary DayName
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
        /^m[ou]n(day)?$/i             => :monday,
        /^t(ue|eu|oo|u)s?(day)?$/i    => :tuesday,
        /^we(d|dnes|nds|nns)(day)?$/i => :wednesday,
        /^th(u|ur|urs|ers)(day)?$/i   => :thursday,
        /^fr[iy](day)?$/i             => :friday,
        /^sat(t?[ue]rday)?$/i         => :saturday,
        /^su[nm](day)?$/i             => :sunday
      }
    end

    def to_s
      'dayname-' << @type.to_s
    end
  end

end
