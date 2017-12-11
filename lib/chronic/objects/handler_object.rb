require 'chronic/handlers/general'

module Chronic
  class HandlerObject

    attr_accessor :local_date
    attr_reader :begin
    attr_reader :width
    attr_reader :precision
    def initialize(tokens, token_index, definitions, local_date, options)
      @tokens = tokens
      @begin = token_index
      @local_date = local_date
      @options = options
      @context = @options[:context]
      @width = 0
      @index = token_index
    end

    def end
      @begin + @width - 1
    end

    def range
      @begin..(@begin + @width - 1)
    end

    def overlap?(r2)
      r1 = range
      (r1.begin <= r2.end) and (r2.begin <= r1.end)
    end

    def is_valid?
      false
    end

    def local_day
      [@local_date.year, @local_date.month, @local_date.day]
    end

    def local_time
      [@local_date.hour, @local_date.min, @local_date.sec + @local_date.usec.to_f / (10 ** 6)]
    end

    protected

    def match(tokens, token_index, definitions)
      definitions.each do |definition|
        if Handler.match(tokens, token_index, definition.first)
          self.method(definition.last).call
          @width = @index - @begin
          puts "\nHandler: #{self.class.name}.#{definition.last.to_s} @ #{@begin}-#{self.end} =>\n=======> #{self}" if Chronic.debug and @width > 0
          return
        end
      end
      @width = 0
    end

    def get_sign
      (@context == :past) ? -1 : ((@context == :future) ? 1 : 0)
    end

    def get_modifier
      (@grabber == :last) ? -1 : ((@grabber == :next) ? 1 : 0)
    end

    def next_tag
      @index += 1
    end

    def handle_possible(tag)
      if @tokens[@index].get_tag(tag)
        next_tag
        return true
      end
      false
    end

  end

end
