module Chronic
  class Time
    HOUR_SECONDS = 3600 # 60 * 60
    MINUTE_SECONDS = 60
    SECOND_SECONDS = 1 # haha, awesome
    SUBSECOND_SECONDS = 0.001

    # Checks if given number could be hour
    def self.could_be_hour?(hour, width = nil, hours12 = false)
      hour >= 0 && hour <= (hours12 ? 12 : 24) && (width.nil? || width > 0)
    end

    # Checks if given number could be minute
    def self.could_be_minute?(minute, width = nil)
      minute >= 0 && minute <= 60 && (width.nil? || width <= 2)
    end

    # Checks if given number could be second
    def self.could_be_second?(second, width = nil)
      second >= 0 && second <= 60 && (width.nil? || width <= 2)
    end

    # Checks if given number could be subsecond
    def self.could_be_subsecond?(subsecond, width = nil)
      subsecond >= 0 && subsecond <= 999999 && (width.nil? || width > 0)
    end

    # normalize offset in seconds to offset as string +mm:ss or -mm:ss
    def self.normalize_offset(offset)
      return offset if offset.is_a?(String)
      offset = Chronic.time_class.now.to_time.utc_offset unless offset # get current system's UTC offset if offset is nil
      sign = '+'
      sign = '-' if offset < 0
      hours = (offset.abs / 3600).to_i.to_s.rjust(2,'0')
      minutes = (offset.abs % 3600).to_s.rjust(2,'0')
      sign + hours + minutes
    end

  end
end
