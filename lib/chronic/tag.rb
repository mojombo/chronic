module Chronic
  # Tokens are tagged with subclassed instances of this class when
  # they match specific criteria.
  class Tag

    attr_accessor :type

    # type - The Symbol type of this tag.
    def initialize(type)
      @type = type
    end

    # time - Set the start Time for this Tag.
    def start=(time)
      @now = time
    end

    class << self
      private

      def scan_for(token, klass, items={})
        case items
        when Regexp
          return klass.new(token.word) if items =~ token.word
        when Hash
          items.each do |item, symbol|
            return klass.new(symbol) if item =~ token.word
          end
        end
        nil
      end

    end

  end
end