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

    def initialize(type)
      super

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

      full_day = 60 * 60 * 24

      if !@current_span
        now_seconds = @now - Chronic.construct(@now.year, @now.month, @now.day)
        if now_seconds < @range.begin
          case pointer
          when :future
            range_start = Chronic.construct(@now.year, @now.month, @now.day) + @range.begin
          when :past
            range_start = Chronic.construct(@now.year, @now.month, @now.day) - full_day + @range.begin
          end
        elsif now_seconds > @range.end
          case pointer
          when :future
            range_start = Chronic.construct(@now.year, @now.month, @now.day) + full_day + @range.begin
          when :past
            range_start = Chronic.construct(@now.year, @now.month, @now.day) + @range.begin
          end
        else
          case pointer
          when :future
            range_start = Chronic.construct(@now.year, @now.month, @now.day) + full_day + @range.begin
          when :past
            range_start = Chronic.construct(@now.year, @now.month, @now.day) - full_day + @range.begin
          end
        end

        @current_span = Span.new(range_start, range_start + (@range.end - @range.begin))
      else
        case pointer
        when :future
          @current_span += full_day
        when :past
          @current_span -= full_day
        end
      end
    end

    def this(context = :future)
      super

      range_start = Chronic.construct(@now.year, @now.month, @now.day) + @range.begin
      @current_span = Span.new(range_start, range_start + (@range.end - @range.begin))
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
  end
end