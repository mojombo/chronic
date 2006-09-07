require 'test/unit'

tests = Dir["#{File.dirname(__FILE__)}/test_*.rb"]
tests.delete_if { |o| o =~ /test_parsing/ }
tests.each do |file|
  require file
end

require File.dirname(__FILE__) + '/test_parsing.rb'