module Chronic
  # Tokens are tagged with subclassed instances of this class when
  # they match specific criteria.
  class Tag
    SNAKE_TO_CAMEL_MAP = {}

    def self.inherited(subclass)
      subclass_string = subclass.name[(subclass.name.rindex('::')+2)..-1]
      subclass_string.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
      subclass_string.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
      subclass_string.downcase!
      SNAKE_TO_CAMEL_MAP[subclass_string] = subclass
    end

    def self.find_by_snake_name(underscore_string)
      SNAKE_TO_CAMEL_MAP[underscore_string]
    end

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
