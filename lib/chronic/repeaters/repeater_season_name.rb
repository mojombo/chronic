module Chronic
  class RepeaterSeasonName < RepeaterSeason #:nodoc:
    SEASON_SECONDS = 7_862_400 # 91 * 24 * 60 * 60
    DAY_SECONDS = 86_400 # (24 * 60 * 60)

    def next(pointer)
      direction = pointer == :future ? 1 : -1
      find_next_season_span(direction, @type)
    end

    def this(pointer = :future)
      direction = pointer == :future ? 1 : -1

      today = Chronic.construct(@now.year, @now.month, @now.day)
      goal_ssn_start = today + direction * num_seconds_til_start(@type, direction)
      goal_ssn_end = today + direction * num_seconds_til_end(@type, direction)
      curr_ssn = find_current_season(MiniDate.from_time(@now))
      case pointer
      when :past
        this_ssn_start = goal_ssn_start
        this_ssn_end = (curr_ssn == @type) ? today : goal_ssn_end
      when :future
        this_ssn_start = (curr_ssn == @type) ? today + RepeaterDay::DAY_SECONDS : goal_ssn_start
        this_ssn_end = goal_ssn_end
      when :none
        this_ssn_start = goal_ssn_start
        this_ssn_end = goal_ssn_end
      end

      construct_season(this_ssn_start, this_ssn_end)
    end

    def offset(span, amount, pointer)
      Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
    end

    def offset_by(time, amount, pointer)
      direction = pointer == :future ? 1 : -1
      time + amount * direction * RepeaterYear::YEAR_SECONDS
    end

  end
end