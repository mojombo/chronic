require 'chronic/handlers/narrow'

module Chronic
  class NarrowObject < HandlerObject
    attr_reader :number
    attr_reader :wday
    attr_reader :unit
    def initialize(tokens, token_index, definitions, local_date, options)
      super
      handle_possible(SeparatorSpace) if handle_possible(KeywordOn)
      match(tokens, @index, definitions)
    end

    def is_valid?
      true
    end

    def to_s
      "number #{@number.inspect}, wday #{@wday.inspect}, unit #{@unit.inspect}, grabber #{@grabber.inspect}"
    end

    def to_span(span = nil, timezone = nil)
      start = @local_date
      start = span.begin if span
      hour, minute, second, utc_offset = Time::split(start)
      end_hour = end_minute = end_second = 0
      modifier = get_modifier
      sign = get_sign
      if @wday
        diff = Date::wday_diff(start, @wday, 0, 0)
        diff += Date::WEEK_DAYS if diff < 0
        diff += Date::WEEK_DAYS * (@number - 1) if @number > 1
        year, month, day = Date::add_day(start.year, start.month, start.day, diff)
        end_year, end_month, end_day = year, month, day
        end_hour += Date::DAY_HOURS
      else
        case @unit
        when :year
          # TODO
          raise "Not Implemented NarrowObject #{@unit.inspect}"
        when :season
          # TODO
          raise "Not Implemented NarrowObject #{@unit.inspect}"
        when :quarter
          this_quarter = Date::get_quarter_index(start.month)
          diff = Date::quarter_diff(this_quarter, @number, modifier, sign)
          year, quarter = Date::add_quarter(start.year, this_quarter, diff)
          year = start.year if span
          month = Date::QUARTERS[quarter]
          end_year, next_quarter = Date::add_quarter(year, quarter)
          end_month = Date::QUARTERS[next_quarter]
          day = end_day = 1
          hour = minute = second = 0
        when :month
          day = start.day
          year, month = Date::add_month(start.year, start.month, @number - 1)
          end_year, end_month, end_day = year, month, day
          end_year, end_month = Date::add_month(year, month, 1)
        when :fortnight, :week, :weekend, :weekday
          # TODO
          raise "Not Implemented NarrowObject #{@unit.inspect}"
        when :day
          year, month, day = Date::add_day(start.year, start.month, start.day, @number - 1)
          end_year, end_month, end_day = year, month, day
          end_hour += Date::DAY_HOURS
        when :morning, :noon, :afternoon, :evening, :night, :midnight, :hour, :minute, :second, :milisecond
          # TODO
          raise "Not Implemented NarrowObject #{@unit.inspect}"
        else
          raise "Uknown unit #{@unit.inspect}!"
        end
      end
      span_start = Chronic.construct(year, month, day, hour, minute, second, timezone)
      return nil if span and span_start >= span.end
      span_end = Chronic.construct(end_year, end_month, end_day, end_hour, end_minute, end_second, timezone)
      span_end = span.end if span and span_end > span.end
      Span.new(span_start, span_end, true)
    end

    protected

    include NarrowHandlers

  end
end
