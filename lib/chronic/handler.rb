module Chronic
  class Handler

    attr_reader :pattern

    attr_reader :handler_method

    # pattern        - An Array of patterns to match tokens against.
    # handler_method - A Symbol representing the method to be invoked
    #   when a pattern matches.
    def initialize(pattern, handler_method)
      @pattern = pattern
      @handler_method = handler_method
    end

    # tokens - An Array of tokens to process.
    # definitions - A Hash of definitions to check against.
    #
    # Returns true if a match is found.
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
            raise "Invalid subset #{name} specified"
          end

          sub_handlers.each do |sub_handler|
            return true if sub_handler.match(tokens[token_index..tokens.size], definitions)
          end
        else
          raise "Invalid match type: #{element.class}"
        end
      end

      return false if token_index != tokens.size
      return true
    end

    def invoke(type, tokens, parser, options)
      if Chronic.debug
        puts "-#{type}"
        puts "Handler: #{@handler_method}"
      end

      parser.send(@handler_method, tokens, options)
    end

    # other - The other Handler object to compare.
    #
    # Returns true if these Handlers match.
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
