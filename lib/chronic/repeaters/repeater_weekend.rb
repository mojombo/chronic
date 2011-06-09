module Chronic
  class RepeaterWeekend < Repeater #:nodoc:
    WEEKEND_SECONDS = 172_800 # (2 * 24 * 60 * 60)

    def initialize(type)
      super
    end

    def next(pointer)
      super

      if !@current_week_start
        case pointer
        when :future
          saturday_repeater = RepeaterDayName.new(:saturday)
          saturday_repeater.start = @now
          next_saturday_span = saturday_repeater.next(:future)
          @current_week_start = next_saturday_span.begin
        when :past
          saturday_repeater = RepeaterDayName.new(:saturday)
          saturday_repeater.start = (@now + RepeaterDay::DAY_SECONDS)
          last_saturday_span = saturday_repeater.next(:past)
          @current_week_start = last_saturday_span.begin
        end
      else
        direction = pointer == :future ? 1 : -1
        @current_week_start += direction * RepeaterWeek::WEEK_SECONDS
      end

      Span.new(@current_week_start, @current_week_start + WEEKEND_SECONDS)
    end

    def this(pointer = :future)
      super

      case pointer
      when :future, :none
        saturday_repeater = RepeaterDayName.new(:saturday)
        saturday_repeater.start = @now
        this_saturday_span = saturday_repeater.this(:future)
        Span.new(this_saturday_span.begin, this_saturday_span.begin + WEEKEND_SECONDS)
      when :past
        saturday_repeater = RepeaterDayName.new(:saturday)
        saturday_repeater.start = @now
        last_saturday_span = saturday_repeater.this(:past)
        Span.new(last_saturday_span.begin, last_saturday_span.begin + WEEKEND_SECONDS)
      end
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1
      weekend = RepeaterWeekend.new(:weekend)
      weekend.start = span.begin
      start = weekend.next(pointer).begin + (amount - 1) * direction * RepeaterWeek::WEEK_SECONDS
      Span.new(start, start + (span.end - span.begin))
    end

    def width
      WEEKEND_SECONDS
    end

    def to_s
      super << '-weekend'
    end
  end
end