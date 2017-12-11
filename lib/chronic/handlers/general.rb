module Chronic
  module GeneralHandlers
    def reset_handler
      @index = @begin
      @grabber = nil
      @day_special = nil
      @time_special = nil
      @precision = nil
    end

    # Handle at
    # formats: at
    def handle_at
      handle_possible(KeywordAt)
      handle_possible(SeparatorSpace)
    end

    # Handle in
    # formats: in
    def handle_in
      handle_possible(KeywordIn)
      handle_possible(SeparatorSpace)
    end

    # Handle grabber
    # formats: gr
    def handle_gr
      @grabber = @tokens[@index].get_tag(Grabber).type
      @index += 1
    end

    # Handle ordinal
    # formats: o
    def handle_o
      @number = @tokens[@index].get_tag(Ordinal).type
      @count = @number
      @index += 1
    end

    # Handle scalar
    # formats: s
    def handle_s
      @count = @tokens[@index].get_tag(Scalar).type
      @index += 1
    end

    # Handle scalar-year
    # formats: yyyy
    def handle_sy
      handle_possible(SeparatorSpace)
      handle_possible(SeparatorApostrophe)
      @year = @tokens[@index].get_tag(ScalarYear).type
      @have_year = true
      @index += 1
      @precision = :year
    end

    # Handle rational
    # formats: r
    def handle_r
      @count = @tokens[@index].get_tag(Rational).type
      @index += 1
    end

    # Handle unit
    # formats: u
    def handle_u
      @unit = @tokens[@index].get_tag(Unit).type
      @index += 1
      @precision = :unit
    end

    # Handle time-special
    # formats: ts
    def handle_ts
      handle_at
      handle_in
      @time_special = @tokens[@index].get_tag(TimeSpecial).type
      @index += 1
      @precision = :time_special
    end

    # Handle day-special
    # formats: ds
    def handle_ds
      @day_special = @tokens[@index].get_tag(DaySpecial).type
      @index += 1
      @precision = :day_special
    end

    # Handle day-name
    # formats: dn
    def handle_dn
      @wday = Date::DAYS[@tokens[@index].get_tag(DayName).type]
      @index += 1
      @precision = :day
    end

    # Handle month-name
    # formats: month
    def handle_mn
      handle_possible(SeparatorSpace)
      handle_possible(SeparatorSpace) if handle_possible(KeywordIn)
      @month = Date::MONTHS[@tokens[@index].get_tag(MonthName).type]
      @index += 1
      @precision = :month
    end

    # Handle season-name
    # formats: season
    def handle_sn
      handle_possible(SeparatorSpace)
      @season = @tokens[@index].get_tag(SeasonName).type
      @index += 1
      @precision = :season
    end

    # Handle keyword-q/scalar
    # formats: Qs
    def handle_q_s
      next_tag # Q
      @quarter = @tokens[@index].get_tag(Scalar).type
      @number = @quarter
      @index += 1
      @precision = :quarter
      @unit = :quarter
    end

  end
end
