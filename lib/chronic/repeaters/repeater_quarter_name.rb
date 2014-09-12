module Chronic
  class RepeaterQuarterName < RepeaterQuarter #:nodoc:
    QUARTERS = {
      :q1 => 0,
      :q2 => 1,
      :q3 => 2,
      :q4 => 3
    }

    def next(pointer)
      unless @current_span
        @current_span = this(pointer)
      else
        year_offset = pointer == :future ? 1 : -1
        new_year = @current_span.begin.year + year_offset
        time_basis = Chronic.construct(new_year, @current_span.begin.month)
        @current_span = quarter(time_basis)
      end

      @current_span
    end

    def this(pointer = :future)
      current_quarter_index = quarter_index(@now.month)
      target_quarter_index = QUARTERS[type]

      year_basis_offset = case pointer
      when :past then current_quarter_index > target_quarter_index ? 0 : -1
      when :future then current_quarter_index < target_quarter_index ? 0 : 1
      else 0
      end

      year_basis = @now.year + year_basis_offset
      month_basis = (MONTHS_PER_QUARTER * target_quarter_index) + 1
      time_basis = Chronic.construct(year_basis, month_basis)

      @current_span = quarter(time_basis)
    end
  end
end
