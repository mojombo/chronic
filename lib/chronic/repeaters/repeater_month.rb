module Chronic
  class RepeaterMonth < Repeater #:nodoc:
    MONTH_SECONDS = 2_592_000 # 30 * 24 * 60 * 60
    YEAR_MONTHS = 12
    MONTH_DAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    MONTH_DAYS_LEAP = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    def initialize(type, options = {})
      super
      @current_month_start = nil
    end

    def next(pointer)
      super

      unless @current_month_start
        @current_month_start = offset_by(Chronic.construct(@now.year, @now.month), 1, pointer)
      else
        @current_month_start = offset_by(Chronic.construct(@current_month_start.year, @current_month_start.month), 1, pointer)
      end

      Span.new(@current_month_start, Chronic.construct(@current_month_start.year, @current_month_start.month + 1))
    end

    def this(pointer = :future)
      super

      case pointer
      when :future
        month_start = Chronic.construct(@now.year, @now.month, @now.day + 1)
        month_end = self.offset_by(Chronic.construct(@now.year, @now.month), 1, :future)
      when :past
        month_start = Chronic.construct(@now.year, @now.month)
        month_end = Chronic.construct(@now.year, @now.month, @now.day)
      when :none
        month_start = Chronic.construct(@now.year, @now.month)
        month_end = self.offset_by(Chronic.construct(@now.year, @now.month), 1, :future)
      end

      Span.new(month_start, month_end)
    end

    def offset(span, amount, pointer)
      Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
    end

    def offset_by(time, amount, pointer)
      direction = pointer == :future ? 1 : -1

      amount_years = direction * amount / YEAR_MONTHS
      amount_months = direction * amount % YEAR_MONTHS

      new_year = time.year + amount_years
      new_month = time.month + amount_months
      if new_month > YEAR_MONTHS
        new_year += 1
        new_month -= YEAR_MONTHS
      end

      days = month_days(new_year, new_month)
      new_day = time.day > days ? days : time.day

      Chronic.construct(new_year, new_month, new_day, time.hour, time.min, time.sec)
    end

    def width
      MONTH_SECONDS
    end

    def to_s
      super << '-month'
    end

    private

    def month_days(year, month)
      ::Date.leap?(year) ? MONTH_DAYS_LEAP[month - 1] : MONTH_DAYS[month - 1]
    end
  end
end
