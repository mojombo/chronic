module Chronic
  class RepeaterQuarter < Repeater
    QUARTER_SECONDS = 7_862_400 # 13 * 7 * 24 * 60 * 60
    QUARTERS = {
      :first => Quarter.new(MiniDate.new(1,1), MiniDate.new(3,31)),
      :second => Quarter.new(MiniDate.new(4,1), MiniDate.new(6,30)),
      :third => Quarter.new(MiniDate.new(7,1), MiniDate.new(9,30)),
      :fourth => Quarter.new(MiniDate.new(10,1), MiniDate.new(12,31)),
    }

    def initialize(type)
      super
    end

    def next(pointer)
      super

      direction = pointer == :future ? 1 : -1
      next_quarter = Quarter.find_next_quarter(find_current_quarter(MiniDate.from_time(@now)), direction)

      find_next_quarter_span(direction, next_quarter)
    end

    def this(pointer = :future)
      super

      direction = pointer == :future ? 1 : -1

      today = Chronic.construct(@now.year, @now.month, @now.day)
      this_qtr = find_current_quarter(MiniDate.from_time(@now))
      case pointer
      when :past
        this_qtr_start = today + direction * num_seconds_til_start(this_qtr, direction)
        this_qtr_end = today
      when :future
        this_qtr_start = today + RepeaterDay::DAY_SECONDS
        this_qtr_end = today + direction * num_seconds_til_end(this_qtr, direction)
      when :none
        this_qtr_start = today + direction * num_seconds_til_start(this_qtr, direction)
        this_qtr_end = today + direction * num_seconds_til_end(this_qtr, direction)
      end

      construct_quarter(this_qtr_start, this_qtr_end)
    end

    def offset(span, amount, pointer)
      Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
    end

    def offset_by(time, amount, pointer)
      direction = pointer == :future ? 1 : -1
      time + amount * direction * QUARTER_SECONDS
    end

    def width
      QUARTER_SECONDS
    end

    def to_s
      super << '-quarter'
    end

    private

    def find_next_quarter_span(direction, next_quarter)
      unless @next_quarter_start or @next_quarter_end
        @next_quarter_start = Chronic.construct(@now.year, @now.month, @now.day)
        @next_quarter_end = Chronic.construct(@now.year, @now.month, @now.day)
      end

      @next_quarter_start += direction * num_seconds_til_start(next_quarter, direction)
      @next_quarter_end += direction * num_seconds_til_end(next_quarter, direction)

      construct_quarter(@next_quarter_start, @next_quarter_end)
    end

    def find_current_quarter(md)
      [:first, :second, :third, :fourth].find do |quarter|
        md.is_between?(QUARTERS[quarter].start, QUARTERS[quarter].end)
      end
    end

    def num_seconds_til(goal, direction)
      start = Chronic.construct(@now.year, @now.month, @now.day)
      seconds = 0

      until MiniDate.from_time(start + direction * seconds).equals?(goal)
        seconds += RepeaterDay::DAY_SECONDS
      end

      seconds
    end

    def num_seconds_til_start(quarter_symbol, direction)
      num_seconds_til(QUARTERS[quarter_symbol].start, direction)
    end

    def num_seconds_til_end(quarter_symbol, direction)
      num_seconds_til(QUARTERS[quarter_symbol].end, direction)
    end

    def construct_quarter(start, finish)
      Span.new(
        Chronic.construct(start.year, start.month, start.day),
        Chronic.construct(finish.year, finish.month, finish.day)
      )
    end
  end
end