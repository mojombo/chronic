require 'chronic/handlers/date_time'

module Chronic
  class DateTimeObject < HandlerObject
    include DateStructure
    include TimeStructure
    include TimeZoneStructure

    def initialize(tokens, token_index, definitions, local_date, options)
      super
      @normalized = false
      match(tokens, @index, definitions)
    end

    def normalize!
      return if @normalized
      adjust!
      @normalized = true
    end

    def is_valid?
      normalize!
      return false if @year.nil? or @month.nil? or @day.nil? or @hour.nil? or @minute.nil? or @second.nil?
      ::Date.valid_date?(@year, @month, @day)
    end

    def get_end
      year = @year
      month = @month
      day = @day
      hour = @hour
      minute = @minute
      second = @second
      if @precision == :subsecond
        minute, second = Time::add_second(minute, second, 1.0 / @subsecond_size)
      else
        minute, second = Time::add_second(minute, second)
      end
      [year, month, day, hour, minute, second]
    end

    def to_span
      span_start = Chronic.construct(@year, @month, @day, @hour, @minute, @second, self)
      end_year, end_month, end_day, end_hour, end_minute, end_second = get_end
      span_end = Chronic.construct(end_year, end_month, end_day, end_hour, end_minute, end_second, self)
      Span.new(span_start, span_end, true)
    end

    def to_s
      "year #{@year.inspect}, month #{@month.inspect}, day #{@day.inspect}, hour #{@hour.inspect}, minute #{@minute.inspect}, second #{@second.inspect}, subsecond #{@subsecond.inspect}"
    end

    protected

    def adjust!
      @second ||= 0
      @second += @subsecond if @subsecond
      @subsecond = 0
    end

    include DateTimeHandlers

  end
end
