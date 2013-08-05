module Chronic
  class RepeaterDay < Repeater #:nodoc:
    DAY_SECONDS = 86_400 # (24 * 60 * 60)

    def initialize(type, options = {})
      super
      @current_day_start = nil
    end

    def next(pointer)
      super

      unless @current_day_start
        @current_day_start = Chronic.time_class.local(@now.year, @now.month, @now.day)
      end

      direction = pointer == :future ? 1 : -1
      @current_day_start += direction * DAY_SECONDS

      Span.new(@current_day_start, @current_day_start + DAY_SECONDS)
    end

    def this(pointer = :future)
      super

      case pointer
      when :future
        day_begin = Chronic.construct(@now.year, @now.month, @now.day, @now.hour)
        day_end = Chronic.construct(@now.year, @now.month, @now.day) + DAY_SECONDS
      when :past
        day_begin = Chronic.construct(@now.year, @now.month, @now.day)
        day_end = Chronic.construct(@now.year, @now.month, @now.day, @now.hour)
      when :none
        day_begin = Chronic.construct(@now.year, @now.month, @now.day)
        day_end = Chronic.construct(@now.year, @now.month, @now.day) + DAY_SECONDS
      end

      Span.new(day_begin, day_end)
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1
      span + direction * amount * DAY_SECONDS
    end

    def width
      DAY_SECONDS
    end

    def to_s
      super << '-day'
    end
  end
end
