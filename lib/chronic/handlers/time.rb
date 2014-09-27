require 'chronic/handlers/general'

module Chronic
  module TimeHandlers
    include GeneralHandlers
    # Handle scalar-hour/scalar-minute/scalar-second/scalar-subsecond
    # formats: h:m:s.SSS, h:m:s:SSS
    def handle_h_m_s_ss
      handle_h_m_s
      next_tag
      subsecond = @tokens[@index].get_tag(ScalarSubsecond)
      @subsecond_size = 10 ** subsecond.width
      @subsecond = subsecond.type.to_f / subsecond_size
      next_tag
      @precision = :subsecond
    end

    # Handle scalar-hour/scalar-minute/scalar-second/day-portion
    # formats: h:m:s dp
    def handle_h_m_s_dp
      handle_h_m_s
      handle_dp
    end

    # Handle scalar-hour/scalar-minute/scalar-second
    # formats: h:m:s
    def handle_h_m_s
      handle_h_m
      next_tag
      handle_s
    end

    # Handle scalar-wide/day-portion
    # formats: hhmm dp
    def handle_hhmm_dp
      handle_hhmm
      handle_dp
    end

    # Handle scalar-hour/scalar-minute/time-special
    # formats: h:m in ts
    def handle_h_m_ts
      handle_h_m
      next_tag
      next_tag # in
      next_tag
      handle_ts
      @precision = :minute
    end

    # Handle scalar-hour/scalar-minute/day-portion
    # formats: h:m dp, h.m dp
    def handle_h_m_dp
      handle_h_m
      handle_dp
    end

    # Handle time-special/scalar-hour/scalar-minute
    # formats: ts at h:m
    def handle_ts_h_m
      handle_ts
      next_tag
      handle_h_m
    end

    # Handle time-special/scalar-hour
    # formats: ts at h
    def handle_ts_h
      handle_ts
      next_tag
      handle_h
    end

    # Handle scalar-hour/scalar-minute
    # formats: h:m, h.m
    def handle_h_m
      handle_h
      next_tag
      handle_m
    end

    # Handle scalar-wide
    # formats: hhmm
    def handle_hhmm
      handle_at
      wide = @tokens[@index].get_tag(ScalarWide).type
      @hour = wide[0, 2].to_i
      @minute = wide[2, 4].to_i
      @ambiguous = false
      next_tag
      @precision = :minute
    end

    # Handle grabber/day-portion
    # formats: gr dp
    def handle_gr_dp
      handle_gr
      next_tag
      handle_dp
    end

    # Handle scalar-hour/time-special
    # formats: h at|in ts
    def handle_h_ts
      handle_h
      next_tag
      handle_ts
      @precision = :hour
    end

    # Handle scalar-hour/day-portion
    # formats: h dp
    def handle_h_dp
      handle_h
      handle_possible(SeparatorSpace)
      handle_dp
    end

    # Handle scalar-hour/keyword-to/scalar-hour
    # formats: h to h
    def handle_h_h
      handle_h
      next_tag # space
      next_tag # to
      next_tag # space
      handle_h
    end

    # Handle scalar-hour
    # formats: h
    def handle_h
      handle_at
      handle_possible(SeparatorSpace)
      tag = @tokens[@index].get_tag(ScalarHour)
      @hour = tag.type
      @ambiguous = false if @hour.zero? or @hour > 12 or (tag.width >= 2 and @hour < 10 and @options[:hours24] != false)
      next_tag
      @precision = :hour
    end

    # Handle scalar-minute
    # formats: m
    def handle_m
      @minute = @tokens[@index].get_tag(ScalarMinute).type
      next_tag
      @precision = :minute
    end

    # Handle scalar-second
    # formats: s
    def handle_s
      @second = @tokens[@index].get_tag(ScalarSecond).type
      next_tag
      @precision = :second
    end

    # Handle day-portion
    # formats: dp
    def handle_dp
      handle_at
      handle_in
      @day_portion = @tokens[@index].get_tag(DayPortion).type
      next_tag
    end

  end
end
