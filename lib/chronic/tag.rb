module Chronic
  # Tokens are tagged with subclassed instances of this class when
  # they match specific criteria.
  class Tag

    attr_accessor :type

    # type - The Symbol type of this tag.
    def initialize(type, options = {})
      @type = type
      @options = options
    end

    # time - Set the start Time for this Tag.
    def start=(time)
      @now = time
    end

    class << self
      private

      def scan_for(token, klass, items={}, options = {})
        case items
        when Regexp
          return klass.new(token.word, options) if items =~ token.word
        when Hash
          items.each do |item, symbol|
            return klass.new(symbol, options) if item =~ token.word
          end
        end
        nil
      end

    end

  end
end