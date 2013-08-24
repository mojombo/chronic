module Chronic
  class Date
    YEAR_MONTHS = 12
    MONTH_DAYS        = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    MONTH_DAYS_LEAP   = [nil, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    YEAR_SECONDS      = 31_536_000 # 365 * 24 * 60 * 60
    SEASON_SECONDS    =  7_862_400 #  91 * 24 * 60 * 60
    MONTH_SECONDS     =  2_592_000 #  30 * 24 * 60 * 60
    FORTNIGHT_SECONDS =  1_209_600 #  14 * 24 * 60 * 60
    WEEK_SECONDS      =    604_800 #   7 * 24 * 60 * 60
    WEEKEND_SECONDS   =    172_800 #   2 * 24 * 60 * 60
    DAY_SECONDS       =     86_400 #       24 * 60 * 60
    MONTHS = {
      :january => 1,
      :february => 2,
      :march => 3,
      :april => 4,
      :may => 5,
      :june => 6,
      :july => 7,
      :august => 8,
      :september => 9,
      :october => 10,
      :november => 11,
      :december => 12
    }
    DAYS = {
      :sunday => 0,
      :monday => 1,
      :tuesday => 2,
      :wednesday => 3,
      :thursday => 4,
      :friday => 5,
      :saturday => 6
    }

    # Checks if given number could be day
    def self.could_be_day?(day)
      day >= 1 && day <= 31
    end

    # Checks if given number could be month
    def self.could_be_month?(month)
      month >= 1 && month <= 12
    end

    # Checks if given number could be year
    def self.could_be_year?(year)
      year >= 1 && year <= 9999
    end

    # Build a year from a 2 digit suffix.
    #
    # year - The two digit Integer year to build from.
    # bias - The Integer amount of future years to bias.
    #
    # Examples:
    #
    #   make_year(96, 50) #=> 1996
    #   make_year(79, 20) #=> 2079
    #   make_year(00, 50) #=> 2000
    #
    # Returns The Integer 4 digit year.
    def self.make_year(year, bias)
      return year if year.to_s.size > 2
      start_year = Chronic.time_class.now.year - bias
      century = (start_year / 100) * 100
      full_year = century + year
      full_year += 100 if full_year < start_year
      full_year
    end

    def self.month_overflow?(year, month, day)
      if ::Date.leap?(year)
        day > Date::MONTH_DAYS_LEAP[month]
      else
        day > Date::MONTH_DAYS[month]
      end
    end

  end
end
