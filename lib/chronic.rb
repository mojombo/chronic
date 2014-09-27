require 'time'
require 'date'
require 'numerizer'

require 'chronic/version'

require 'chronic/parser'
require 'chronic/date'
require 'chronic/time'

require 'chronic/handler'
require 'chronic/handlers'
require 'chronic/mini_date'
require 'chronic/span'
require 'chronic/token'
require 'chronic/tokenizer'
require 'chronic/season'

require 'chronic/tag'
require 'chronic/tags/grabber'
require 'chronic/tags/ordinal'
require 'chronic/tags/pointer'
require 'chronic/tags/scalar'
require 'chronic/tags/separator'
require 'chronic/tags/sign'
require 'chronic/tags/time_zone'

require 'chronic/tags/repeater'
require 'chronic/repeaters/repeater_year'
require 'chronic/repeaters/repeater_quarter'
require 'chronic/repeaters/repeater_quarter_name'
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
module Chronic

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
  self.time_class = ::Time


  # Parses a string containing a natural language date or time.
  #
  # If the parser can find a date or time, either a Time or Chronic::Span
  # will be returned (depending on the value of `:guess`). If no
  # date or time can be found, `nil` will be returned.
  #
  # text - The String text to parse.
  # opts - An optional Hash of configuration options passed to Parser::new.
  def self.parse(text, options = {})
    Parser.new(options).parse(text)
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
  def self.construct(year, month = 1, day = 1, hour = 0, minute = 0, second = 0, offset = nil)
    day, hour, minute, second = Time::normalize(day, hour, minute, second)

    year, month, day = Date::add_day(year, month, day, 0) if day > 28
    year, month = Date::add_month(year, month, 0) if month > 12

    if Chronic.time_class.name == 'Date'
      Chronic.time_class.new(year, month, day)
    elsif not Chronic.time_class.respond_to?(:new) or (RUBY_VERSION.to_f < 1.9 and Chronic.time_class.name == 'Time')
      Chronic.time_class.local(year, month, day, hour, minute, second)
    else
      offset = Time::normalize_offset(offset) if Chronic.time_class.name == 'DateTime'
      Chronic.time_class.new(year, month, day, hour, minute, second, offset)
    end
  end

end
