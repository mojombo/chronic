require 'chronic/handlers/anchor'

module Chronic
  class AnchorObject < HandlerObject
    attr_reader :grabber
    attr_reader :unit
    attr_reader :season
    attr_reader :month
    attr_reader :wday
    attr_reader :day_special
    attr_reader :time_special
    attr_reader :count
    def initialize(tokens, token_index, definitions, local_date, options)
      super
      match(tokens, @index, definitions)
    end

    def is_valid?
      true
    end

    def to_s
      "grabber #{@grabber.inspect}, unit #{@unit.inspect}, season #{@season.inspect}, month #{@month.inspect}, wday #{@wday.inspect}, day special #{@day_special.inspect}, time special #{@time_special.inspect}, count #{@count.inspect}"
    end

    def to_span(span = nil, time = nil, timezone = nil)
      modifier = get_modifier
      if span
        year, month, day = Date::split(span.begin)
      else
        year, month, day = local_day
      end
      time = TimeInfo.new(@local_date) unless time
      hour, minute, second = time.to_a
      time_precision = false
      if time.is_a?(TimeObject)
      @precision = time.precision
      time_precision = true
      end
      date = Chronic.time_class.new(year, month, day)
      end_year, end_month, end_day = year, month, day
      end_hour, end_minute, end_second = time.get_end
      if @count
        modifier = @count - 1
        @context == :future
      end
      sign = get_sign
      if @season
        season = Date::SEASON_DATES[@season]
        diff = Date::month_diff(month, season.first, modifier, sign)
        year, month = Date::add_month(year, month, diff)
        day = season.last
        end_year, next_season = Date::add_season(year, @season)
        end_month, end_day = Date::SEASON_DATES[next_season]
        hour = minute = second = end_hour = end_minute = end_second = 0
      elsif @month
        diff = Date::month_diff(month, @month, modifier, sign)
        year, month = Date::add_month(year, month, diff)
        end_year, end_month = Date::add_month(year, month)
        day = end_day = 1
        hour = minute = second = end_hour = end_minute = end_second = 0
      elsif @wday
        diff = Date::wday_diff(date, @wday, modifier.zero? ? 1 : modifier, 0)
        year, month, day = Date::add_day(year, month, day, diff) unless diff.zero?
        end_year, end_month, end_day = year, month, day
        unless time_precision
          end_year, end_month, end_day = Date::add_day(year, month, day)
          hour = minute = second = 0 if [year, month, day] != local_date
          end_hour = end_minute = end_second = 0
        end
      elsif @day_special
        case @day_special
        when :yesterday
          year, month, day = Date::add_day(year, month, day, -1)
          if time_precision
            end_year, end_month, end_day = year, month, day
          else
            end_year, end_month, end_day = Date::add_day(year, month, day)
            hour = minute = second = end_hour = end_minute = end_second = 0
          end
        when :today
          unless time_precision
            end_year, end_month, end_day = Date::add_day(year, month, day)
            end_hour = end_minute = end_second = 0
          end
        when :tomorrow
          year, month, day = Date::add_day(year, month, day)
          if time_precision
            end_year, end_month, end_day = year, month, day
          else
            end_year, end_month, end_day = Date::add_day(year, month, day)
            hour = minute = second = end_hour = end_minute = end_second = 0
          end
        else
          raise "Uknown day special #{@day_special.inspect}"
        end
      elsif @time_special
        year, month, day = Date::add_day(year, month, day, modifier)
        end_year, end_month, end_day = year, month, day
        hour = Time::SPECIAL[@time_special].begin
        end_hour = Time::SPECIAL[@time_special].end
        minute = second = end_minute = end_second = 0
      else
        case @unit
        when :year
          year += modifier
          unless modifier.zero? and @context == :future
            month = 1
            day = 1
            hour = minute = second = 0
          end
          unless modifier.zero? and @context == :past
            end_year = year + 1
            end_month = 1
            end_day = 1
            end_hour = end_minute = end_second = 0
          end
        when :month
          year, month = Date::add_month(year, month, modifier)
          unless modifier.zero? and @context == :future
            day = 1
            hour = minute = second = 0
          end
          unless modifier.zero? and @context == :past
            end_year, end_month = Date::add_month(year, month)
            end_day = 1
            end_hour = end_minute = end_second = 0
          end
        when :fortnight
          unless modifier.zero? and @context == :future
            diff = Date::wday_diff(date, Date::DAYS[@options[:week_start]], modifier, sign)
            diff -= Date::WEEK_DAYS
            year, month, day = Date::add_day(year, month, day, diff)
            date = Chronic.time_class.new(year, month, day)
            hour = minute = second = 0
          end
          unless modifier.zero? and @context == :past
            end_date = Chronic.time_class.new(year, month, day)
            diff = Date::wday_diff(end_date, Date::DAYS[@options[:week_start]], modifier, sign)
            end_year, end_month, end_day = Date::add_day(year, month, day, diff + Date::WEEK_DAYS)
            end_hour = end_minute = end_second = 0
          end
        when :week
          unless modifier.zero? and @context == :future
            diff = Date::wday_diff(date, Date::DAYS[@options[:week_start]], 0, 0)
            diff += Date::WEEK_DAYS * modifier
            year, month, day = Date::add_day(year, month, day, diff)
            hour = minute = second = 0
          end
          unless modifier.zero? and @context == :past
            end_date = Chronic.time_class.new(year, month, day)
            diff = Date::wday_diff(end_date, Date::DAYS[@options[:week_start]], 1, 0)
            end_year, end_month, end_day = Date::add_day(year, month, day, diff)
            end_hour = end_minute = end_second = 0
          end
        when :weekend
          diff = Date::wday_diff(date, Date::DAYS[:saturday], modifier, sign)
          year, month, day = Date::add_day(year, month, day, diff)
          if [year, month, day] != local_date or @context == :past
            hour = minute = second = 0
          end
          if [year, month, day] != local_date or @context == :future
            end_date = Chronic.time_class.new(year, month, day)
            diff = Date::wday_diff(end_date, Date::DAYS[:monday], 1, 1)
            end_year, end_month, end_day = Date::add_day(year, month, day, diff)
            end_hour = end_minute = end_second = 0
          end
        when :weekday
          diff = Date::wd_diff(date, modifier)
          year, month, day = Date::add_day(year, month, day, diff)
          if [year, month, day] != local_date or @context == :past
            hour = minute = second = 0
          end
          if [year, month, day] != local_date or @context == :future
            end_year, end_month, end_day = Date::add_day(year, month, day)
            end_hour = end_minute = end_second = 0
          end
        when :day
          unless modifier.zero? and @context == :future
            year, month, day = Date::add_day(year, month, day, modifier)
            hour = minute = second = 0
          end
          unless modifier.zero? and @context == :past or time_precision
            end_year, end_month, end_day = Date::add_day(year, month, day)
            end_hour = end_minute = end_second = 0
          end
        when :morning, :noon, :afternoon, :evening, :night, :midnight
          unless modifier.zero? and @context == :future
            year, month, day = Date::add_day(year, month, day, modifier)
            hour = Time::SPECIAL[@unit].begin
            minute = second = 0
          end
          unless modifier.zero? and @context == :past
            end_year, end_month, end_day = Date::add_day(year, month, day)
            end_hour = Time::SPECIAL[@unit].end
            end_minute = end_second = 0
          end
        when :hour
          unless modifier.zero? and @context == :future
            day, hour = Time::add_hour(day, hour, modifier)
            minute = second = 0
          end
          unless modifier.zero? and @context == :past
            end_day, end_hour = Time::add_hour(day, hour)
            end_minute = end_second = 0
          end
        when :minute
          unless modifier.zero? and @context == :future
            hour, minute = Time::add_minute(hour, minute, modifier)
            second = 0
          end
          unless modifier.zero? and @context == :past
            end_hour, end_minute = Time::add_minute(hour, minute)
            end_second = 0
          end
        when :second
          unless modifier.zero? and @context == :future
            minute, second = Time::add_second(minute, second, modifier)
            hour, minute = Time::add_minute(hour, minute, 0)
          end
          unless modifier.zero? and @context == :past
            end_hour = hour
            end_minute, end_second = Time::add_second(minute, second)
          end
        else
          raise "Uknown unit #{unit.inspect}"
        end
      end
      span_start = Chronic.construct(year, month, day, hour, minute, second, timezone)
      span_end = Chronic.construct(end_year, end_month, end_day, end_hour, end_minute, end_second, timezone)
      span = Span.new(span_start, span_end, true)
      span.precision = @precision
      span
    end

    protected

    include AnchorHandlers

  end
end