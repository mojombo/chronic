#module Chronic

  class Chronic::Grabber < Chronic::Tag #:nodoc:
    def self.scan(tokens)
      tokens.each_index do |i|
        if t = self.scan_for_all(tokens[i]) then tokens[i].tag(t); next end
      end
      tokens
    end
    
    def self.scan_for_all(token)
      scanner = {/last/ => :last,
                 /this/ => :this,
                 /next/ => :next}
      scanner.keys.each do |scanner_item|
        return self.new(scanner[scanner_item]) if scanner_item =~ token.word
      end
      return nil
    end
    
    def to_s
      'grabber-' << @type.to_s
    end
  end

#end