module Chronic
  class Date

    # Checks if given number could be day
    def self.could_be_day?(day)
      return true if day >= 1 and day <= 31
      false
    end

    # Checks if given number could be month
    def self.could_be_month?(month)
      return true if month >= 1 and month <= 12
      false
    end

    # Checks if given number could be year
    def self.could_be_year?(year)
      return true if year >= 1 and year <= 9999
      false
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

  end
end
