module Chronic
  class RepeaterQuarterName < RepeaterQuarter
    QUARTER_SECONDS = 7_862_400 # 13 * 7 * 24 * 60 * 60
    DAY_SECONDS = 86_400 # (24 * 60 * 60)

    def next(pointer)
      direction = pointer == :future ? 1: -1
      find_next_quarter_span(direction, @type)
    end

    def this(pointer = :future)
      direction = pointer == :future ? 1 : -1

      today = Chronic.construct(@now.year, @now.month, @now.day)
      goal_qtr_start = today + direction * num_seconds_til_start(@type, direction)
      goal_qtr_end = today + direction * num_seconds_til_end(@type, direction)
      curr_qtr = find_current_quarter(MiniDate.from_time(@now))
      case pointer
      when :past
        this_qtr_start = goal_qtr_start
        this_qtr_end = (curr_qtr == @type) ? today : goal_qtr_end
      when :future
        this_qtr_start = (curr_qtr == @type) ? today + RepeaterDay::DAY_SECONDS : goal_qtr_start
        this_qtr_end = goal_qtr_end
      when :none
        this_qtr_start = goal_qtr_start
        this_qtr_end = goal_qtr_end
      end

      construct_quarter(this_qtr_start, this_qtr_end)
    end

    def offset(span, amount, pointer)
      Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
    end

    def offset_by(time, amount, pointer)
      direction = pointer == :future ? 1 : -1
      time + amount * direction * RepeaterYear::Year_SECONDS
    end
    
  end
end