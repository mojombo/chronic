require 'chronic/handlers/arrow'

module Chronic
  class ArrowObject < HandlerObject
    attr_reader :count
    attr_reader :unit
    attr_reader :special
    attr_reader :pointer
    def initialize(tokens, token_index, definitions, local_date, options)
      super
      match(tokens, @index, definitions)
    end

    def is_valid?
      true
    end

    def to_s
      "count #{@count.inspect}, unit #{@unit.inspect}, pointer #{@pointer.inspect}, special #{@special.inspect}"
    end

    protected

    include ArrowHandlers

  end
end
