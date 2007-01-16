#=============================================================================
#
#  Name:       Chronic
#  Author:     Tom Preston-Werner
#  Purpose:    Parse natural language dates and times into Time or
#              Chronic::Span objects
#
#=============================================================================

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

module Chronic
  VERSION = "0.1.5"
  
  def self.debug; false; end
end

alias p_orig p

def p(val)
  p_orig val
  puts
end