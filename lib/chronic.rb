#=============================================================================
#
#  Name:       Chronic
#  Author:     Tom Preston-Werner
#  Purpose:    Parse natural language dates and times into Time or
#              Chronic::Span objects
#
#=============================================================================

Dir["#{File.dirname(__FILE__)}/chronic/*.rb"].each do |file|
  require 'chronic/' + File.basename(file)[0..-4]
end

require 'ruby-debug'

module Chronic
  def self.debug=(val); @debug = val; end
end

Chronic.debug = false