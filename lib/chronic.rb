require 'time'
require 'date'

require 'chronic/parser'

require 'chronic/handler'
require 'chronic/handlers'
require 'chronic/mini_date'
require 'chronic/tag'
require 'chronic/span'
require 'chronic/token'
require 'chronic/grabber'
require 'chronic/pointer'
require 'chronic/scalar'
require 'chronic/ordinal'
require 'chronic/ordinal'
require 'chronic/separator'
require 'chronic/time_zone'
require 'chronic/numerizer'
require 'chronic/season'

require 'chronic/repeater'
require 'chronic/repeaters/repeater_year'
require 'chronic/repeaters/repeater_season'
require 'chronic/repeaters/repeater_season_name'
require 'chronic/repeaters/repeater_month'
require 'chronic/repeaters/repeater_month_name'
require 'chronic/repeaters/repeater_fortnight'
require 'chronic/repeaters/repeater_week'
require 'chronic/repeaters/repeater_weekend'
require 'chronic/repeaters/repeater_weekday'
require 'chronic/repeaters/repeater_day'
require 'chronic/repeaters/repeater_day_name'
require 'chronic/repeaters/repeater_day_portion'
require 'chronic/repeaters/repeater_hour'
require 'chronic/repeaters/repeater_minute'
require 'chronic/repeaters/repeater_second'
require 'chronic/repeaters/repeater_time'

# Parse natural language dates and times into Time or Chronic::Span objects.
#
# Examples:
#
#   require 'chronic'
#
#   Time.now   #=> Sun Aug 27 23:18:25 PDT 2006
#
#   Chronic.parse('tomorrow')
#     #=> Mon Aug 28 12:00:00 PDT 2006
#
#   Chronic.parse('monday', :context => :past)
#     #=> Mon Aug 21 12:00:00 PDT 2006
#
#   Chronic.parse('this tuesday 5:00')
#     #=> Tue Aug 29 17:00:00 PDT 2006
#
#   Chronic.parse('this tuesday 5:00', :ambiguous_time_range => :none)
#     #=> Tue Aug 29 05:00:00 PDT 2006
#
#   Chronic.parse('may 27th', :now => Time.local(2000, 1, 1))
#     #=> Sat May 27 12:00:00 PDT 2000
#
#   Chronic.parse('may 27th', :guess => false)
#     #=> Sun May 27 00:00:00 PDT 2007..Mon May 28 00:00:00 PDT 2007
module Chronic
  VERSION = "0.8.0"

  class << self

    # Returns true when debug mode is enabled.
    attr_accessor :debug

    # Examples:
    #
    #   require 'chronic'
    #   require 'active_support/time'
    #
    #   Time.zone = 'UTC'
    #   Chronic.time_class = Time.zone
    #   Chronic.parse('June 15 2006 at 5:54 AM')
    #     # => Thu, 15 Jun 2006 05:45:00 UTC +00:00
    #
    # Returns The Time class Chronic uses internally.
    attr_accessor :time_class
  end

  self.debug = false
  self.time_class = Time

  class << self

    # Parses a string containing a natural language date or time.
    #
    # If the parser can find a date or time, either a Time or Chronic::Span
    # will be returned (depending on the value of `:guess`). If no
    # date or time can be found, `nil` will be returned.
    #
    # text - The String text to parse.
    # opts - An optional Hash of configuration options:
    #        :context - If your string represents a birthday, you can set
    #                   this value to :past and if an ambiguous string is
    #                   given, it will assume it is in the past.
    #        :now - Time, all computations will be based off of time
    #               instead of Time.now.
    #        :guess - By default the parser will guess a single point in time
    #                 for the given date or time. If you'd rather have the
    #                 entire time span returned, set this to false
    #                 and a Chronic::Span will be returned.
    #        :ambiguous_time_range - If an Integer is given, ambiguous times
    #                  (like 5:00) will be assumed to be within the range of
    #                  that time in the AM to that time in the PM. For
    #                  example, if you set it to `7`, then the parser will
    #                  look for the time between 7am and 7pm. In the case of
    #                  5:00, it would assume that means 5:00pm. If `:none`
    #                  is given, no assumption will be made, and the first
    #                  matching instance of that time will be used.
    #        :endian_precedence - By default, Chronic will parse "03/04/2011"
    #                 as the fourth day of the third month. Alternatively you
    #                 can tell Chronic to parse this as the third day of the
    #                 fourth month by setting this to [:little, :middle].
    #        :ambiguous_year_future_bias - When parsing two digit years
    #                 (ie 79) unlike Rubys Time class, Chronic will attempt
    #                 to assume the full year using this figure. Chronic will
    #                 look x amount of years into the future and past. If the
    #                 two digit year is `now + x years` it's assumed to be the
    #                 future, `now - x years` is assumed to be the past.
    #
    # Returns a new Time object, or Chronic::Span if :guess option is false.
    def parse(text, opts={})
      Parser.new(opts).parse(text)
    end

    # Construct a new time object determining possible month overflows
    # and leap years.
    #
    # year   - Integer year.
    # month  - Integer month.
    # day    - Integer day.
    # hour   - Integer hour.
    # minute - Integer minute.
    # second - Integer second.
    #
    # Returns a new Time object constructed from these params.
    def construct(year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
      if second >= 60
        minute += second / 60
        second = second % 60
      end

      if minute >= 60
        hour += minute / 60
        minute = minute % 60
      end

      if hour >= 24
        day += hour / 24
        hour = hour % 24
      end

      # determine if there is a day overflow. this is complicated by our crappy calendar
      # system (non-constant number of days per month)
      day <= 56 || raise("day must be no more than 56 (makes month resolution easier)")
      if day > 28
        # no month ever has fewer than 28 days, so only do this if necessary
        leap_year_month_days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        common_year_month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        days_this_month = Date.leap?(year) ? leap_year_month_days[month - 1] : common_year_month_days[month - 1]
        if day > days_this_month
          month += day / days_this_month
          day = day % days_this_month
        end
      end

      if month > 12
        if month % 12 == 0
          year += (month - 12) / 12
          month = 12
        else
          year += month / 12
          month = month % 12
        end
      end

      Chronic.time_class.local(year, month, day, hour, minute, second)
    end
  end

end
