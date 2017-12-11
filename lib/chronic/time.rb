module Chronic
  class Time
    DAY_HOURS         = 24
    HOUR_MINUTES      = 60
    HOUR_SECONDS      = 3600 # 60 * 60
    MINUTE_SECONDS    = 60
    SECOND_SECONDS    = 1 # haha, awesome
    SUBSECOND_SECONDS = 0.001
    SPECIAL = {
      :am        => (0... 12), #  0am to 12pm
      :pm        => (12...24), # 12am to  0am
      :morning   => (6... 12), #  6am to 12pm
      :noon      => (12.. 12), # 12pm
      :afternoon => (13...17), #  1pm to 5pm
      :evening   => (17...20), #  5pm to 8pm
      :night     => (20...24), #  8pm to 0am
      :midnight  => (24.. 24)  #  0am
    }

    # Checks if given number could be hour
    def self.could_be_hour?(hour, width = nil, hours12 = false)
      hour >= 0 && hour <= (hours12 ? 12 : 24) && (width.nil? || width > 0)
    end

    # Checks if given number could be minute
    def self.could_be_minute?(minute, width = nil)
      minute >= 0 && minute <= HOUR_MINUTES && (width.nil? || width <= 2)
    end

    # Checks if given number could be second
    def self.could_be_second?(second, width = nil)
      second >= 0 && second <= MINUTE_SECONDS && (width.nil? || width <= 2)
    end

    # Checks if given number could be subsecond
    def self.could_be_subsecond?(subsecond, width = nil)
      subsecond >= 0 && subsecond <= 99999999 && (width.nil? || width > 0)
    end

    def self.add_second(minute, second, amount = 1)
      second += amount
      if second >= MINUTE_SECONDS or second < 0
        minute += second / MINUTE_SECONDS
        second = second % MINUTE_SECONDS
      end
      [minute, second]
    end

    def self.add_minute(hour, minute, amount = 1)
      minute += amount
      if minute >= HOUR_MINUTES or minute < 0
        hour += minute / HOUR_MINUTES
        minute = minute % HOUR_MINUTES
      end
      [hour, minute]
    end

    def self.add_hour(day, hour, amount = 1)
      hour += amount
      if hour >= DAY_HOURS or hour < 0
        day += hour / DAY_HOURS
        hour = hour % DAY_HOURS
      end
      [day, hour]
    end

    def self.normalize(day, hour, minute, second)
      minute, second = add_second(minute, second, 0)
      hour, minute = add_minute(hour, minute, 0)
      day, hour = add_hour(day, hour, 0)
      [day, hour, minute, second]
    end

    def self.split(time)
      if time.is_a?(::Time) or time.is_a?(::DateTime)
        [time.hour, time.min, time.sec, time.to_time.utc_offset]
      else
        [0, 0, 0, nil]
      end
    end
  end

  module TimeStructure
    include Comparable
    attr_accessor :hour
    attr_accessor :minute
    attr_accessor :second
    attr_reader :subsecond
    attr_reader :subsecond_size
    attr_reader :precision
    def update(time)
      @hour = time.hour
      @minute = time.min
      @second = time.sec
      self
    end

    def is_equal?(time)
      @hour == time.hour &&
      @minute == time.min &&
      @second == time.sec
    end

    def <=> (time)
      to_f <=> time.hour * Time::HOUR_SECONDS + time.min * Time::MINUTE_SECONDS + time.sec
    end

    def to_a
      [@hour, @minute, @second]
    end

    def to_f
      @hour * Time::HOUR_SECONDS + @minute * Time::MINUTE_SECONDS + @second
    end

    def get_end
      [@hour, @minute, @second]
    end

    def to_span(date, timezone = nil)
      span_start = Chronic.construct(date.year, date.month, date.day, @hour, @minute, @second, timezone)
      end_hour, end_minute, end_second = get_end
      span_end = Chronic.construct(date.year, date.month, date.day, end_hour, end_minute, end_second, timezone)
      Span.new(span_start, span_end, true)
    end
  end

  class TimeInfo
    include TimeStructure
    def initialize(now = nil)
      if now
        update(now)
      else
        @hour = 0
        @minute = 0
        @second = 0
      end
    end
  end

end
