#=============================================================================
#
#  Name:       Chronic
#  Author:     Tom Preston-Werner
#  Purpose:    Parse natural language dates and times into Time or
#              Chronic::Span objects
#
#=============================================================================

require 'date'

require 'chronic/chronic'
require 'chronic/handlers'
require 'chronic/grabber'
require 'chronic/ordinal'
require 'chronic/pointer'
require 'chronic/scalar'
require 'chronic/separator'

require 'chronic/repeater'
Dir["#{File.dirname(__FILE__)}/chronic/repeaters/*.rb"].each do |file|
  require file
end

module Chronic
  def self.debug=(val); @debug = val; end
end

Chronic.debug = false

