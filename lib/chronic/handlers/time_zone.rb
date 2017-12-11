module Chronic
  module TimeZoneHandlers

    # Handle offset
    # formats: UTC, Z
    def handle_generic
      @offset = @tokens[@index].get_tag(TimeZoneGeneric).type
      next_tag
    end

    # Handle abbr
    # formats: UTC, GMT, etc
    def handle_abbr
      @abbr = @tokens[@index].get_tag(TimeZoneAbbreviation).type
      next_tag
    end

    # Handle scalar-wide
    # formats: hhmm
    def handle_hhmm
      handle_sign
      wide = @tokens[@index].get_tag(ScalarWide).type
      @tzhour = wide[0, 2].to_i
      @tzminute = wide[2, 4].to_i
      next_tag
    end

    # Handle sign/scalar-hour/scalar-minute
    # formats: +hh:mm, -hh:mm
    def handle_hh_mm
      handle_sign
      @tzhour = @tokens[@index].get_tag(ScalarHour).type
      next_tag
      next_tag
      @tzminute = @tokens[@index].get_tag(ScalarMinute).type
      next_tag
    end

    # Handle sign
    # formats: +, -
    def handle_sign
      sign = @tokens[@index].get_tag(Sign)
      if sign
        @sign = sign
        next_tag
      end
    end

  end
end
