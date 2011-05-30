module Chronic

  class Pointer < Tag #:nodoc:
    def self.scan(tokens)
      # for each token
      tokens.each_index do |i|
        if t = self.scan_for_all(tokens[i]) then tokens[i].tag(t) end
      end
    end

    def self.scan_for_all(token)
      scan_for token, self,
      {
        /\bpast\b/ => :past,
        /\bfuture\b/ => :future,
        /\bin\b/ => :future
      }
    end

    def to_s
      'pointer-' << @type.to_s
    end
  end

end
