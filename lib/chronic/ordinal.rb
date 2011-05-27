module Chronic

  class Ordinal < Tag #:nodoc:
    def self.scan(tokens)
      # for each token
      tokens.each_index do |i|
        if t = self.scan_for_ordinals(tokens[i]) then tokens[i].tag(t) end
        if t = self.scan_for_days(tokens[i]) then tokens[i].tag(t) end
      end
      tokens
    end

    def self.scan_for_ordinals(token)
      Ordinal.new($1.to_i) if token.word =~ /^(\d*)(st|nd|rd|th)$/
    end

    def self.scan_for_days(token)
      if token.word =~ /^(\d*)(st|nd|rd|th)$/
        unless $1.to_i > 31 || $1.to_i < 1
          OrdinalDay.new(token.word.to_i)
        end
      end
    end

    def to_s
      'ordinal'
    end
  end

  class OrdinalDay < Ordinal #:nodoc:
    def to_s
      super << '-day-' << @type.to_s
    end
  end

end
