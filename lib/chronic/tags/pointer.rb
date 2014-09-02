module Chronic
  class Pointer < Tag

    # Scan an Array of Token objects and apply any necessary Pointer
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_all(token, options) then token.tag(t) end
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Pointer object.
    def self.scan_for_all(token, options={})
      scan_for token, self, options[:locale]['pointer.scan_for_all']
    end

    def to_s
      'pointer-' << @type.to_s
    end
  end
end
