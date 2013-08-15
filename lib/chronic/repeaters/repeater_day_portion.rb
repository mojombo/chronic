module Chronic
  class RepeaterDayPortion < Repeater #:nodoc:
    PORTIONS = {
      :am => 0..(12 * 60 * 60 - 1),
      :pm => (12 * 60 * 60)..(24 * 60 * 60 - 1),
      :morning => (6 * 60 * 60)..(12 * 60 * 60),    # 6am-12am,
      :afternoon => (13 * 60 * 60)..(17 * 60 * 60), # 1pm-5pm,
      :evening => (17 * 60 * 60)..(20 * 60 * 60),   # 5pm-8pm,
      :night => (20 * 60 * 60)..(24 * 60 * 60),     # 8pm-12pm
    }

    def initialize(type, options = {})
      super
      @current_span = nil

      if type.kind_of? Integer
        @range = (@type * 60 * 60)..((@type + 12) * 60 * 60)
      else
        @range = PORTIONS[type]
        @range || raise("Invalid type '#{type}' for RepeaterDayPortion")
      end

      @range || raise("Range should have been set by now")
    end

    def next(pointer)
      super

      unless @current_span
        now_seconds = @now - Chronic.construct(@now.year, @now.month, @now.day)
        if now_seconds < @range.begin
          case pointer
          when :future
            range_start = Chronic.construct(@now.year, @now.month, @now.day) + @range.begin
          when :past
            range_start = Chronic.construct(@now.year, @now.month, @now.day - 1) + @range.begin
          end
        elsif now_seconds > @range.end
          case pointer
          when :future
            range_start = Chronic.construct(@now.year, @now.month, @now.day + 1) + @range.begin
          when :past
            range_start = Chronic.construct(@now.year, @now.month, @now.day) + @range.begin
          end
        else
          case pointer
          when :future
            range_start = Chronic.construct(@now.year, @now.month, @now.day + 1) + @range.begin
          when :past
            range_start = Chronic.construct(@now.year, @now.month, @now.day - 1) + @range.begin
          end
        end
        offset = (@range.end - @range.begin)
        range_end = construct_date_from_reference_and_offset(range_start, offset)
        @current_span = Span.new(range_start, range_end)
      else
        days_to_shift_window =
        case pointer
        when :future
          1
        when :past
          -1
        end

        new_begin = Chronic.construct(@current_span.begin.year, @current_span.begin.month, @current_span.begin.day + days_to_shift_window, @current_span.begin.hour, @current_span.begin.min, @current_span.begin.sec)
        new_end = Chronic.construct(@current_span.end.year, @current_span.end.month, @current_span.end.day + days_to_shift_window, @current_span.end.hour, @current_span.end.min, @current_span.end.sec)
        @current_span = Span.new(new_begin, new_end)
      end
    end

    def this(context = :future)
      super

      range_start = Chronic.construct(@now.year, @now.month, @now.day) + @range.begin
      range_end = construct_date_from_reference_and_offset(range_start)
      @current_span = Span.new(range_start, range_end)
    end

    def offset(span, amount, pointer)
      @now = span.begin
      portion_span = self.next(pointer)
      direction = pointer == :future ? 1 : -1
      portion_span + (direction * (amount - 1) * RepeaterDay::DAY_SECONDS)
    end

    def width
      @range || raise("Range has not been set")
      return @current_span.width if @current_span
      if @type.kind_of? Integer
        return (12 * 60 * 60)
      else
        @range.end - @range.begin
      end
    end

    def to_s
      super << '-dayportion-' << @type.to_s
    end

    private
    def construct_date_from_reference_and_offset(reference, offset = nil)
      elapsed_seconds_for_range = offset || (@range.end - @range.begin)
      second_hand = ((elapsed_seconds_for_range - (12 * 60))) % 60
      minute_hand = (elapsed_seconds_for_range - second_hand) / (60) % 60
      hour_hand = (elapsed_seconds_for_range - minute_hand - second_hand) / (60 * 60) + reference.hour % 24
      Chronic.construct(reference.year, reference.month, reference.day, hour_hand, minute_hand, second_hand)
    end
  end
end
