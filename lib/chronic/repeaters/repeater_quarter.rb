module Chronic
  class RepeaterQuarter < Repeater #:nodoc:
    MONTHS_PER_QUARTER = 3
    # QUARTER_SECONDS = 7_776_000 # 3 * 30 * 24 * 60 * 60

    def next(pointer)
      @current_span ||= quarter(@now)
      offset_quarter_amount = pointer == :future ? 1 : -1
      @current_span = offset_quarter(@current_span.begin, offset_quarter_amount)
    end

    def this(*)
      @current_span = quarter(@now)
    end

    def width
      raise 'No current span' unless @current_span
      @current_span.width
    end

    def to_s
      super << '-quarter'
    end

    private

    def quarter(time)
      year, month = time.year, time.month

      quarter_index = month / MONTHS_PER_QUARTER
      quarter_month_start = (quarter_index * MONTHS_PER_QUARTER) + 1
      quarter_month_end = quarter_month_start + MONTHS_PER_QUARTER

      quarter_start = Chronic.construct(year, quarter_month_start)
      quarter_end = Chronic.construct(year, quarter_month_end)

      Span.new(quarter_start, quarter_end)
    end

    def offset_quarter(time, amount)
      new_month = time.month - 1
      new_month = new_month + MONTHS_PER_QUARTER * amount
      new_year = time.year + new_month / 12
      new_month = new_month % 12 + 1

      offset_time_basis = Chronic.construct(new_year, new_month)

      quarter(offset_time_basis)
    end
  end
end
