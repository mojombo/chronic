module Chronic
  class Date
    YEAR_QUARTERS     = 4
    YEAR_MONTHS       = 12
    SEASON_MONTHS     = 3
    QUARTER_MONTHS    = 3
    MONTH_DAYS        = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    MONTH_DAYS_LEAP   = [nil, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    FORTNIGHT_DAYS    = 14
    WEEK_DAYS         =  7
    DAY_HOURS         = 24
    YEAR_SECONDS      = 31_536_000 # 365 * 24 * 60 * 60
    SEASON_SECONDS    =  7_862_400 #  91 * 24 * 60 * 60
    QUARTER_SECONDS   =  7_776_000 #  90 * 24 * 60 * 60
    MONTH_SECONDS     =  2_592_000 #  30 * 24 * 60 * 60
    FORTNIGHT_SECONDS =  1_209_600 #  14 * 24 * 60 * 60
    WEEK_SECONDS      =    604_800 #   7 * 24 * 60 * 60
    WEEKEND_SECONDS   =    172_800 #   2 * 24 * 60 * 60
    DAY_SECONDS       =     86_400 #       24 * 60 * 60
    SEASONS = [
      :spring,
      :summer,
      :autumn,
      :winter
    ]
    SEASON_DATES = {
      :spring => [3, 20],
      :summer => [6, 21],
      :autumn => [9, 23],
      :winter => [12, 22]
    }
    QUARTERS = [nil, 1, 4, 7, 10]
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
    def self.could_be_day?(day, width = nil)
      day >= 1 && day <= 31 && (width.nil? || width <= 2)
    end

    # Checks if given number could be month
    def self.could_be_month?(month, width = nil)
      month >= 1 && month <= 12 && (width.nil? || width <= 2)
    end

    # Checks if given number could be year
    def self.could_be_year?(year, width = nil)
      year >= 0 && year <= 9999 && (width.nil? || width == 2 || width == 4)
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

    def self.days_month(year, month)
      days_month = ::Date.leap?(year) ? Date::MONTH_DAYS_LEAP[month] : Date::MONTH_DAYS[month]
    end

    def self.month_overflow?(year, month, day)
      day > days_month(year, month)
    end

    def self.add_season(year, season, modifier = 1)
      index = SEASONS.index(season) + modifier
      year += index / SEASONS.count
      season = SEASONS[index % SEASONS.count]
      [year, season]
    end

    def self.add_quarter(year, quarter, amount = 1)
      quarter += amount
      if quarter > YEAR_QUARTERS or quarter < 1
        year += (quarter - 1) / YEAR_QUARTERS
        quarter = (quarter - 1) % YEAR_QUARTERS + 1
      end
      [year, quarter]
    end

    def self.add_month(year, month, amount = 1)
      month += amount
      if month > YEAR_MONTHS or month < 1
        year += (month - 1) / YEAR_MONTHS
        month = (month - 1) % YEAR_MONTHS + 1
      end
      [year, month]
    end

    def self.add_day(year, month, day, amount = 1)
      day += amount
      days_month = self.days_month(year, month)
      while day > days_month
        day -= days_month
        year, month = add_month(year, month, 1)
        days_month = self.days_month(year, month)
      end
      days_prev_month = self.days_month(year, (month - 2) % YEAR_MONTHS + 1)
      while day < 1
        day += days_prev_month
        year, month = add_month(year, month, -1)
        days_prev_month = self.days_month(year, month)
      end
      [year, month, day]
    end

    def self.get_quarter_index(month)
      (month - 1) / QUARTER_MONTHS + 1
    end

    def self.get_quarter_month(month)
      (get_quarter_index(month) - 1) * QUARTER_MONTHS + 1
    end

    def self.get_quarter_end(quarter)
      QUARTERS[(quarter - 1) % YEAR_QUARTERS + 1]
    end

    def self.normalize(year, month, day)
      year, month = add_month(year, month, 0)
      year, month, day = add_day(year, month, day, 0)
      [year, month, day]
    end

    def self.split(date)
      [date.year, date.month, date.day]
    end

    def self.calculate_difference(diff, limit, modifier = 1, context = 0)
      state = diff <=> 0
      unless modifier.zero?
        skew = modifier
        skew += (modifier <=> 0) * -1 if diff * modifier > 0
        diff += limit * skew
      end
      unless context.zero?
        if modifier.zero?
          diff += limit * context if state * context <= 0
        elsif state.zero?
          diff += limit * context if modifier * context < 0
        end
      end
      diff
    end

    # Calculate difference in days between given week day and date day
    def self.wday_diff(date, wday, modifier = 1, context = 0)
      self.calculate_difference(wday - date.wday, WEEK_DAYS, modifier, context)
    end

    # Get day difference for weekday
    def self.wd_diff(date, modifier = 1)
      diff = modifier
      wday = date.wday
      if modifier == 0 and wday == DAYS[:sunday]
        diff = 1
      elsif modifier == 0 and wday == DAYS[:saturday]
        diff = 2
      elsif modifier == 1 and wday == DAYS[:friday]
        diff = 3
      elsif modifier == 1 and wday == DAYS[:saturday]
        diff = 2
      elsif modifier == -1 and wday == DAYS[:sunday]
        diff = -2
      elsif modifier == -1 and wday == DAYS[:monday]
        diff = -3
      end
      diff
    end

    # Calculate difference in months between given month and date month
    def self.month_diff(date_month, month, modifier = 1, context = 0)
      self.calculate_difference(month - date_month, YEAR_MONTHS, modifier, context)
    end

    # Calculate difference in quarters between given quarter and date quarter
    def self.quarter_diff(date_quarter, quarter, modifier = 1, context = 0)
      self.calculate_difference(quarter - date_quarter, YEAR_QUARTERS, modifier, context)
    end

  end

  module DateStructure
    attr_accessor :year
    attr_accessor :month
    attr_accessor :day
    attr_accessor :have_year
    attr_accessor :have_month
    attr_accessor :have_day
    attr_reader :precision
    def update(date)
      @year = date.year
      @month = date.month
      @day = date.day
      self
    end

    def is_equal?(date)
      @year == date.year &&
      @month == date.month &&
      @day == date.day
    end

    def add_day(amount = 1)
      @year, @month, @day = Date::add_day(@year, @month, @day, amount)
    end

    def to_a
      [@year, @month, @day]
    end

    def get_end
      [@year, @month, @day]
    end

    def to_span(time = nil, timezone = nil)
      hour = minute = second = 0
      hour, minute, second = time.to_a if time
      span_start = Chronic.construct(@year, @month, @day, hour, minute, second, timezone)
      end_year, end_month, end_day = get_end
      span_end = Chronic.construct(end_year, end_month, end_day, 0, 0, 0, timezone)
      span = Span.new(span_start, span_end, true)
      span.precision = @precision
      span.precision = time.precision if time and time.precision
      span
    end
  end

  class DateInfo
    include DateStructure
    def initialize(now = nil)
      @now = now ? now : Chronic.time_class.now
      update(@now)
    end
  end

end
