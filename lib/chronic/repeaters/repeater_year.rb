module Chronic
  class RepeaterYear < Repeater #:nodoc:
    YEAR_SECONDS =  31536000  # 365 * 24 * 60 * 60

    def initialize(type)
      super
    end

    def next(pointer)
      super

      if !@current_year_start
        case pointer
        when :future
          @current_year_start = Chronic.construct(@now.year + 1)
        when :past
          @current_year_start = Chronic.construct(@now.year - 1)
        end
      else
        diff = pointer == :future ? 1 : -1
        @current_year_start = Chronic.construct(@current_year_start.year + diff)
      end

      Span.new(@current_year_start, Chronic.construct(@current_year_start.year + 1))
    end

    def this(pointer = :future)
      super

      case pointer
      when :future
        this_year_start = Chronic.construct(@now.year, @now.month, @now.day + 1)
        this_year_end = Chronic.construct(@now.year + 1, 1, 1)
      when :past
        this_year_start = Chronic.construct(@now.year, 1, 1)
        this_year_end = Chronic.construct(@now.year, @now.month, @now.day)
      when :none
        this_year_start = Chronic.construct(@now.year, 1, 1)
        this_year_end = Chronic.construct(@now.year + 1, 1, 1)
      end

      Span.new(this_year_start, this_year_end)
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1
      new_begin = build_offset_time(span.begin, amount, direction)
      new_end   = build_offset_time(span.end, amount, direction)
      Span.new(new_begin, new_end)
    end

    def width
      YEAR_SECONDS
    end

    def to_s
      super << '-year'
    end

    private

    def build_offset_time(time, amount, direction)
      year = time.year + (amount * direction)
      days = month_days(year, time.month)
      day = time.day > days ? days : time.day
      Chronic.construct(year, time.month, day, time.hour, time.min, time.sec)
    end

    def month_days(year, month)
      if Date.leap?(year)
        RepeaterMonth::MONTH_DAYS_LEAP[month - 1]
      else
        RepeaterMonth::MONTH_DAYS[month - 1]
      end
    end
  end
end