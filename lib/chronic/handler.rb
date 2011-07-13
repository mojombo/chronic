module Chronic
  class Handler

    # @return [Array] A list of patterns
    attr_reader :pattern

    # @return [Symbol] The method which handles this list of patterns.
    #   This method should exist inside the {Handlers} module
    attr_reader :handler_method

    # @param [Array]  pattern A list of patterns to match tokens against
    # @param [Symbol] handler_method The method to be invoked when patterns
    #   are matched. This method should exist inside the {Handlers} module
    def initialize(pattern, handler_method)
      @pattern = pattern
      @handler_method = handler_method
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

        case element
        when Symbol
          if tags_match?(name, tokens, token_index)
            token_index += 1
            next
          else
            if optional
              next
            else
              return false
            end
          end
        when String
          return true if optional && token_index == tokens.size

          if definitions.key?(name.to_sym)
            sub_handlers = definitions[name.to_sym]
          else
            raise ChronicPain, "Invalid subset #{name} specified"
          end

          sub_handlers.each do |sub_handler|
            return true if sub_handler.match(tokens[token_index..tokens.size], definitions)
          end
        else
          raise ChronicPain, "Invalid match type: #{element.class}"
        end
      end

      return false if token_index != tokens.size
      return true
    end

    def invoke(type, tokens, options)
      if Chronic.debug
        puts "-#{type}"
        puts "Handler: #{@handler_method}"
      end

      Handlers.send(@handler_method, tokens, options)
    end

    # @param [Handler]  The handler to compare
    # @return [Boolean] True if these handlers match
    def ==(other)
      @pattern == other.pattern
    end

    private

    def tags_match?(name, tokens, token_index)
      klass = Chronic.const_get(name.to_s.gsub(/(?:^|_)(.)/) { $1.upcase })

      if tokens[token_index]
        !tokens[token_index].tags.select { |o| o.kind_of?(klass) }.empty?
      end
    end

  end
end