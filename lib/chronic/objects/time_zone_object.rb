require 'chronic/handlers/time_zone'

module Chronic
  class TimeZoneObject < HandlerObject
    include TimeZoneStructure

    def initialize(tokens, token_index, definitions, local_date, options)
      super
      match(tokens, @index, definitions)
    end

    def normalize!
      return if @normalized
      @offset = to_offset
      @normalized = true
    end

    def is_valid?
      true
    end

    protected

    include TimeZoneHandlers

  end
end
