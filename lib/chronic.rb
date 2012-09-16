require 'time'
require 'date'

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

    # The current Time Chronic is using to base from.
    #
    # Examples:
    #
    #   Time.now #=> 2011-06-06 14:13:43 +0100
    #   Chronic.parse('yesterday') #=> 2011-06-05 12:00:00 +0100
    #
    #   now = Time.local(2025, 12, 24)
    #   Chronic.parse('tomorrow', :now => now) #=> 2025-12-25 12:00:00 +0000
    #
    # Returns a Time object.
    attr_accessor :now
  end

  self.debug = false
  self.time_class = Time

  autoload :Handler, 'chronic/handler'
  autoload :Handlers, 'chronic/handlers'
  autoload :MiniDate, 'chronic/mini_date'
  autoload :Tag, 'chronic/tag'
  autoload :Span, 'chronic/span'
  autoload :Token, 'chronic/token'
  autoload :Grabber, 'chronic/grabber'
  autoload :Pointer, 'chronic/pointer'
  autoload :Scalar, 'chronic/scalar'
  autoload :Ordinal, 'chronic/ordinal'
  autoload :OrdinalDay, 'chronic/ordinal'
  autoload :Separator, 'chronic/separator'
  autoload :TimeZone, 'chronic/time_zone'
  autoload :Numerizer, 'chronic/numerizer'
  autoload :Season, 'chronic/season'

  autoload :Repeater, 'chronic/repeater'
  autoload :RepeaterYear, 'chronic/repeaters/repeater_year'
  autoload :RepeaterSeason, 'chronic/repeaters/repeater_season'
  autoload :RepeaterSeasonName, 'chronic/repeaters/repeater_season_name'
  autoload :RepeaterMonth, 'chronic/repeaters/repeater_month'
  autoload :RepeaterMonthName, 'chronic/repeaters/repeater_month_name'
  autoload :RepeaterFortnight, 'chronic/repeaters/repeater_fortnight'
  autoload :RepeaterWeek, 'chronic/repeaters/repeater_week'
  autoload :RepeaterWeekend, 'chronic/repeaters/repeater_weekend'
  autoload :RepeaterWeekday, 'chronic/repeaters/repeater_weekday'
  autoload :RepeaterDay, 'chronic/repeaters/repeater_day'
  autoload :RepeaterDayName, 'chronic/repeaters/repeater_day_name'
  autoload :RepeaterDayPortion, 'chronic/repeaters/repeater_day_portion'
  autoload :RepeaterHour, 'chronic/repeaters/repeater_hour'
  autoload :RepeaterMinute, 'chronic/repeaters/repeater_minute'
  autoload :RepeaterSecond, 'chronic/repeaters/repeater_second'
  autoload :RepeaterTime, 'chronic/repeaters/repeater_time'

end

require 'chronic/chronic'

class Time

  def self.construct(year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
    warn "Time.construct will be deprecated in version 0.7.0. Please use Chronic.construct instead"
    Chronic.construct(year, month, day, hour, minute, second)
  end

  def to_minidate
    warn "Time.to_minidate will be deprecated in version 0.7.0. Please use Chronic::MiniDate.from_time(time) instead"
    Chronic::MiniDate.from_time(self)
  end

end
