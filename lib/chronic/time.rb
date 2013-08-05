module Chronic
  class Time

    # Checks if given number could be hour
    def self.could_be_hour?(day)
      return true if day >= 0 and day <= 24
      false
    end

    # Checks if given number could be minute
    def self.could_be_minute?(month)
      return true if month >= 0 and month <= 60
      false
    end

    # Checks if given number could be second
    def self.could_be_second?(year)
      return true if year >= 0 and year <= 60
      false
    end

    # Checks if given number could be subsecond
    def self.could_be_subsecond?(subsecond)
      return true if subsecond >= 0 and subsecond <= 999999
      false
    end

  end
end
