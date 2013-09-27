module Chronic
  class RepeaterWeek < Repeater #:nodoc:
    WEEK_SECONDS = 604800 # (7 * 24 * 60 * 60)

    def initialize(type, options = {})
      super
      @repeater_day_name = options[:week_start] || :sunday
      @current_week_start = nil
    end

    def next(pointer)
      super

      unless @current_week_start
        case pointer
        when :future
          first_week_day_repeater = RepeaterDayName.new(@repeater_day_name)
          first_week_day_repeater.start = @now
          next_span = first_week_day_repeater.next(:future)
          @current_week_start = next_span.begin
        when :past
          first_week_day_repeater = RepeaterDayName.new(@repeater_day_name)
          first_week_day_repeater.start = (@now + RepeaterDay::DAY_SECONDS)
          first_week_day_repeater.next(:past)
          last_span = first_week_day_repeater.next(:past)
          @current_week_start = last_span.begin
        end
      else
        direction = pointer == :future ? 1 : -1
        @current_week_start += direction * WEEK_SECONDS
      end

      Span.new(@current_week_start, @current_week_start + WEEK_SECONDS)
    end

    def this(pointer = :future)
      super

      case pointer
      when :future
        this_week_start = Chronic.time_class.local(@now.year, @now.month, @now.day, @now.hour) + RepeaterHour::HOUR_SECONDS
        first_week_day_repeater = RepeaterDayName.new(@repeater_day_name)
        first_week_day_repeater.start = @now
        this_span = first_week_day_repeater.this(:future)
        this_week_end = this_span.begin
        Span.new(this_week_start, this_week_end)
      when :past
        this_week_end = Chronic.time_class.local(@now.year, @now.month, @now.day, @now.hour)
        first_week_day_repeater = RepeaterDayName.new(@repeater_day_name)
        first_week_day_repeater.start = @now
        last_span = first_week_day_repeater.next(:past)
        this_week_start = last_span.begin
        Span.new(this_week_start, this_week_end)
      when :none
        first_week_day_repeater = RepeaterDayName.new(@repeater_day_name)
        first_week_day_repeater.start = @now
        last_span = first_week_day_repeater.next(:past)
        this_week_start = last_span.begin
        Span.new(this_week_start, this_week_start + WEEK_SECONDS)
      end
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1
      span + direction * amount * WEEK_SECONDS
    end

    def width
      WEEK_SECONDS
    end

    def to_s
      super << '-week'
    end
  end
end
