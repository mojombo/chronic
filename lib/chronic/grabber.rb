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
        if t = scan_for_all(token) then token.tag(t); next end
      end
    end

    # token - The Token object to scan.
    #
    # Returns a new Grabber object.
    def self.scan_for_all(token)
      scan_for token, self,
      {
        /last/ => :last,
        /this/ => :this,
        /next/ => :next
      }
    end

    def to_s
      'grabber-' << @type.to_s
    end
  end
end