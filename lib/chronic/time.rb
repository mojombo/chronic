module Chronic
  class Time

    # Checks if given number could be hour
    def self.could_be_hour?(hour)
      hour >= 0 && hour <= 24
    end

    # Checks if given number could be minute
    def self.could_be_minute?(minute)
      minute >= 0 && minute <= 60
    end

    # Checks if given number could be second
    def self.could_be_second?(second)
      second >= 0 && second <= 60
    end

    # Checks if given number could be subsecond
    def self.could_be_subsecond?(subsecond)
      subsecond >= 0 && subsecond <= 999999
    end

  end
end
