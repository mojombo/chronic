module Chronic
  class RepeaterFortnight < Repeater #:nodoc:
    FORTNIGHT_SECONDS = 1_209_600 # (14 * 24 * 60 * 60)

    def initialize(type, options = {})
      super
      @current_fortnight_start = nil
    end

    def next(pointer)
      super

      unless @current_fortnight_start
        case pointer
        when :future
          sunday_repeater = RepeaterDayName.new(:sunday)
          sunday_repeater.start = @now
          next_sunday_span = sunday_repeater.next(:future)
          @current_fortnight_start = next_sunday_span.begin
        when :past
          sunday_repeater = RepeaterDayName.new(:sunday)
          sunday_repeater.start = (@now + RepeaterDay::DAY_SECONDS)
          2.times { sunday_repeater.next(:past) }
          last_sunday_span = sunday_repeater.next(:past)
          @current_fortnight_start = last_sunday_span.begin
        end
      else
        direction = pointer == :future ? 1 : -1
        @current_fortnight_start += direction * FORTNIGHT_SECONDS
      end

      Span.new(@current_fortnight_start, @current_fortnight_start + FORTNIGHT_SECONDS)
    end

    def this(pointer = :future)
      super

      pointer = :future if pointer == :none

      case pointer
      when :future
        this_fortnight_start = Chronic.construct(@now.year, @now.month, @now.day, @now.hour) + RepeaterHour::HOUR_SECONDS
        sunday_repeater = RepeaterDayName.new(:sunday)
        sunday_repeater.start = @now
        sunday_repeater.this(:future)
        this_sunday_span = sunday_repeater.this(:future)
        this_fortnight_end = this_sunday_span.begin
        Span.new(this_fortnight_start, this_fortnight_end)
      when :past
        this_fortnight_end = Chronic.construct(@now.year, @now.month, @now.day, @now.hour)
        sunday_repeater = RepeaterDayName.new(:sunday)
        sunday_repeater.start = @now
        last_sunday_span = sunday_repeater.next(:past)
        this_fortnight_start = last_sunday_span.begin
        Span.new(this_fortnight_start, this_fortnight_end)
      end
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1
      span + direction * amount * FORTNIGHT_SECONDS
    end

    def width
      FORTNIGHT_SECONDS
    end

    def to_s
      super << '-fortnight'
    end
  end
end
