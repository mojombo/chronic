#=============================================================================
#
#  Name:       Chronic
#  Author:     Tom Preston-Werner
#  Purpose:    Parse natural language dates and times into Time or
#              Chronic::Span objects
#
#=============================================================================

$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

require 'time'

require 'chronic/chronic'
require 'chronic/handlers'

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

require 'chronic/grabber'
require 'chronic/pointer'
require 'chronic/scalar'
require 'chronic/ordinal'
require 'chronic/separator'
require 'chronic/time_zone'

require 'numerizer/numerizer'

module Chronic
  VERSION = "0.3.0"
  
  class << self
    attr_accessor :debug
    attr_accessor :time_class
  end

  self.debug = false
  self.time_class = Time
end

# class Time
#   def self.construct(year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
#     # extra_seconds = second > 60 ? second - 60 : 0
#     # extra_minutes = minute > 59 ? minute - 59 : 0
#     # extra_hours = hour > 23 ? hour - 23 : 0
#     # extra_days = day > 
#     
#     if month > 12
#       if month % 12 == 0
#         year += (month - 12) / 12
#         month = 12
#       else
#         year += month / 12
#         month = month % 12
#       end
#     end
#     
#     base = Time.local(year, month)
#     puts base
#     offset = ((day - 1) * 24 * 60 * 60) + (hour * 60 * 60) + (minute * 60) + second
#     puts offset.to_s
#     date = base + offset
#     puts date
#     date
#   end
# end

class Time
  def self.construct(year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
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
      leap_year = (year % 4 == 0) && !(year % 100 == 0)
      leap_year_month_days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
      common_year_month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
      days_this_month = leap_year ? leap_year_month_days[month - 1] : common_year_month_days[month - 1]
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
