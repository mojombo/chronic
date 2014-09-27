require 'chronic/handlers/general'

module Chronic
  module DateHandlers
    include GeneralHandlers

    # Handle scalar-day
    # formats: dd
    def handle_sd
      @day = @tokens[@index].get_tag(ScalarDay).type
      @have_day = true
      @index += 1
      handle_possible(SeparatorComma)
      @precision = :day
    end

    # Handle scalar-month
    # formats: mm
    def handle_sm
      @month = @tokens[@index].get_tag(ScalarMonth).type
      @have_month = true
      @index += 1
      @precision = :month
    end

    # Handle ordinal-day
    # formats: dd(st|nd|rd|th),?
    def handle_od
      @day = @tokens[@index].get_tag(OrdinalDay).type
      @have_day = true
      @index += 1
      handle_possible(SeparatorComma)
      @precision = :day
    end

    # Handle ordinal-month
    # formats: mm(st|nd|rd|th)
    def handle_om
      @month = @tokens[@index].get_tag(OrdinalMonth).type
      @have_month = true
      @index += 1
      @precision = :month
    end



    # Handle scalar-day/month-name
    # formats: dd mn, dd-mn
    def handle_sd_mn
      handle_sd
      handle_possible(SeparatorDash)
      handle_mn
      @precision = :day
    end

    # Handle scalar-day/month-name/scalar-year
    # formats: dd mn yyyy, dd-mn-yyyy
    def handle_sd_mn_sy
      handle_sd_mn
      handle_possible(SeparatorDash)
      handle_sy
      @precision = :day
    end

    # Handle scalar-day/scalar-month
    # formats: dd/mm, dd.mm
    def handle_sd_sm
      handle_sd
      next_tag
      handle_sm
      @precision = :day
    end

    # Handle scalar-day/scalar-month/scalar-year
    # formats: dd/mm/yyyy, dd.mm.yyyy
    def handle_sd_sm_sy
      handle_sd_sm
      next_tag
      handle_sy
      @precision = :day
    end



    # Handle ordinal-day/month-name
    # formats: dd(st|nd|rd|th) mn
    def handle_od_mn
      handle_od
      next_tag
      handle_mn
      @precision = :day
    end

    # Handle ordinal-day/month-name/scalar-year
    # formats: dd(st|nd|rd|th) mn yyyy
    def handle_od_mn_sy
      handle_od
      next_tag
      handle_mn
      handle_possible(SeparatorSpace)
      handle_sy
      @precision = :day
    end



    # Handle day-name/ordinal-day
    # formats: dn od
    def handle_dn_od
      handle_dn
      next_tag
      handle_od
    end

    # Handle day-name/month-name/scalar-day
    # formats: dn month dd
    def handle_dn_mn_sd
      handle_dn
      next_tag
      handle_mn_sd
    end

    # Handle day-name/month-name/scalar-day/scalar-year
    # formats: dn month dd yyyy
    def handle_dn_mn_sd_sy
      handle_dn_mn_sd
      next_tag
      handle_sy
      @precision = :day
    end

    # Handle day-name/month-name/ordinal-day
    # formats: dn month dd
    def handle_dn_mn_od
      handle_dn
      next_tag
      handle_mn_od
    end

    # Handle day-name/month-name/ordinal-day/scalar-year
    # formats: dn month dd yyyy
    def handle_dn_mn_od_sy
      handle_dn_mn_od
      next_tag
      handle_sy
      @precision = :day
    end



    # Handle month-name/scalar-day
    # formats: month dd, month-dd
    def handle_mn_sd
      handle_mn
      next_tag
      handle_sd
    end

    # Handle month-name/scalar-day/scalar-year
    # formats: month dd yyyy
    def handle_mn_sd_sy
      handle_mn
      next_tag
      handle_sd
      handle_possible(SeparatorComma)
      handle_sy
      @precision = :day
    end

    # Handle month-name/ordinal-day
    # formats: month dd, month-dd
    def handle_mn_od
      handle_mn
      next_tag
      handle_od
    end

    # Handle month-name/ordinal-day/scalar-year
    # formats: mn dd yyyy
    def handle_mn_od_sy
      handle_mn
      next_tag
      handle_od
      handle_sy
      @precision = :day
    end

    # Handle month-name/scalar-year
    # formats: month yyyy
    def handle_mn_sy
      handle_mn
      next_tag
      handle_sy
      @precision = :month
    end



    # Handle scalar-month/scalar-day
    # formats: mm/dd
    def handle_sm_sd
      handle_sm
      next_tag
      handle_sd
      @precision = :day
    end

    # Handle scalar-month/scalar-day/scalar-year
    # formats: mm/dd/yyyy
    def handle_sm_sd_sy
      handle_sm_sd
      next_tag
      handle_sy
      @precision = :day
    end



    # Handle scalar-year/scalar-month
    # formats: yyyy-sm
    def handle_sy_sm
      handle_sy
      next_tag
      handle_sm
    end

    # Handle scalar-year/scalar-month/scalar-day
    # formats: yyyy-mm-dd, yyyy.mm.dd, yyyy/mm/dd, yyyy:mm:dd
    def handle_sy_sm_sd
      handle_sy
      next_tag
      handle_sm
      next_tag
      handle_sd
    end

    # Handle scalar-year/month-name
    # formats: yyyy mn
    def handle_sy_mn
      handle_sy
      handle_mn
    end

    # Handle scalar-year/month-name/scalar-day
    # formats: yyyy mn dd
    def handle_sy_mn_sd
      handle_sy
      handle_mn
      next_tag
      handle_sd
    end

    # Handle scalar-year/month-name/ordinal-day
    # formats: yyyy mn dd(st|nd|rd|th)
    def handle_sy_mn_od
      handle_sy
      handle_mn
      next_tag
      handle_od
    end

  end
end
