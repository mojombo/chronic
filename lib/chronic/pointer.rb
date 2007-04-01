module Chronic

  class Pointer < Tag #:nodoc:
    def self.scan(tokens)
      # for each token
      tokens.each_index do |i|
        if t = self.scan_for_all(tokens[i]) then tokens[i].tag(t) end
      end
      tokens
    end
  
    def self.scan_for_all(token)
      scanner = {/\bpast\b/ => :past,
                 /\bfuture\b/ => :future,
                 /\bin\b/ => :future}
      scanner.keys.each do |scanner_item|
        return self.new(scanner[scanner_item]) if scanner_item =~ token.word
      end
      return nil
    end
    
    def to_s
      'pointer-' << @type.to_s
    end
  end

end