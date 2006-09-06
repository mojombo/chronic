require 'test/unit'

tests = Dir["#{File.dirname(__FILE__)}/test_*.rb"]
tests.delete_if { |o| o =~ /test_parsing/ }
tests.each do |file|
  require File.basename(file)[0..-4]
end

require 'test_parsing'