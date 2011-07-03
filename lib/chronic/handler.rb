module Chronic
  class Handler

    # @return [Array] A list of patterns
    attr_accessor :pattern

    # @return [Symbol] The method which handles this list of patterns.
    #   This method should exist inside the {Handlers} module
    attr_accessor :handler_method

    # @param [Array]  pattern A list of patterns to match tokens against
    # @param [Symbol] handler_method The method to be invoked when patterns
    #   are matched. This method should exist inside the {Handlers} module
    def initialize(pattern, handler_method)
      @pattern = pattern
      @handler_method = handler_method
    end

    # @param [#to_s]  The snake_case name representing a Chronic constant
    # @return [Class] The class represented by `name`
    # @raise [NameError] Raises if this constant could not be found
    def constantize(name)
      Chronic.const_get name.to_s.gsub(/(^|_)(.)/) { $2.upcase }
    end

    # @param [Array] tokens
    # @param [Hash]  definitions
    # @return [Boolean]
    # @see Chronic.tokens_to_span
    def match(tokens, definitions)
      token_index = 0

      @pattern.each do |element|
        name = element.to_s
        optional = name[-1, 1] == '?'
        name = name.chop if optional

        if element.instance_of? Symbol
          klass = constantize(name)
          match = tokens[token_index] && !tokens[token_index].tags.select { |o| o.kind_of?(klass) }.empty?

          return false if !match && !optional
          (token_index += 1; next) if match
          next if !match && optional
        elsif element.instance_of? String
          return true if optional && token_index == tokens.size
          sub_handlers = definitions[name.intern] || raise(ChronicPain, "Invalid subset #{name} specified")
          sub_handlers.each do |sub_handler|
            return true if sub_handler.match(tokens[token_index..tokens.size], definitions)
          end
          return false
        else
          raise ChronicPain, "Invalid match type: #{element.class}"
        end
      end
      return false if token_index != tokens.size
      return true
    end

    # @param [Handler]  The handler to compare
    # @return [Boolean] True if these handlers match
    def ==(other)
      @pattern == other.pattern
    end

  end
end