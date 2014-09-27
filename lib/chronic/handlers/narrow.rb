require 'chronic/handlers/general'

module Chronic
  module NarrowHandlers
    include GeneralHandlers

    # Handle ordinal/day-name
    # formats: o u
    def handle_o_dn
      handle_o
      handle_possible(SeparatorSpace)
      handle_dn
    end

    # Handle ordinal/unit
    # formats: o u
    def handle_o_u
      handle_o
      handle_possible(SeparatorSpace)
      handle_u
    end

    # Handle ordinal-day/grabber/unit-month
    # formats: dd(st|nd|rd|th) of last/this/next month
    def handle_od_gr
      handle_od
      next_tag
      handle_gr
      # ignore unit
      @year, @month = Date::add_month(@local_date.year, @local_date.month, @modifier)
      next_tag
    end

    # Handle ordinal-month/grabber/unit-year
    # formats: mm(st|nd|rd|th) of last/this/next year
    def handle_om_gr
      handle_om
      next_tag
      handle_gr
      # ignore unit
      @year = @local_date.year + @modifier
      next_tag
    end

    # Handle grabber/ordinal/unit
    # formats: last/this/next o u
    def handle_gr_o_u
      handle_gr
      next_tag
      handle_o_u
    end

  end
end
