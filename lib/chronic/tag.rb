module Chronic
  # Tokens are tagged with subclassed instances of this class when
  # they match specific criteria
  class Tag #:nodoc:
    attr_accessor :type

    def initialize(type)
      @type = type
    end

    def start=(s)
      @now = s
    end

    class << self
      private

      def scan_for(token, klass, items={})
        items.each do |item, symbol|
          return klass.new(symbol) if item =~ token.word
        end
        nil
      end
    end
  end
end