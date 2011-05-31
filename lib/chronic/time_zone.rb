module Chronic
  class TimeZone < Tag #:nodoc:
    def self.scan(tokens, options)
      tokens.each_index do |i|
        if t = self.scan_for_all(tokens[i]) then tokens[i].tag(t); next end
      end
    end

    def self.scan_for_all(token)
      scan_for token, self,
      {
        /[PMCE][DS]T/i => :tz,
        /(tzminus)?\d{4}/ => :tz
      }
    end

    def to_s
      'timezone'
    end
  end
end
