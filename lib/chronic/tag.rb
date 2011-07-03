module Chronic
  # Tokens are tagged with subclassed instances of this class when
  # they match specific criteria
  class Tag

    # @return [Symbol]
    attr_accessor :type

    # @param [Symbol] type
    def initialize(type)
      @type = type
    end

    # @param [Time] s Set the start timestamp for this Tag
    def start=(s)
      @now = s
    end

    class << self
      private

      # @param [Token] token
      # @param [Class] klass The class instance to create
      # @param [Regexp, Hash] items
      # @return [Object, nil] either a new instance of `klass` or `nil` if
      #   no match is found
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