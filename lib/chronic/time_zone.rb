module Chronic
  class TimeZone < Tag #:nodoc:
    def self.scan(tokens)
      tokens.each_index do |i|
        if t = self.scan_for_all(tokens[i]) then tokens[i].tag(t); next end
      end
    end

    def self.scan_for_all(token)
      {
        /[PMCE][DS]T/i => :tz,
        /(tzminus)?\d{4}/ => :tz
      }.each do |item, symbol|
        return self.new(symbol) if item =~ token.word
      end
      return nil
    end

    def to_s
      'timezone'
    end
  end
end
