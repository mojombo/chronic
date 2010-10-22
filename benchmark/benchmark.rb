require 'chronic'
require 'benchmark'

print "jan 3 2010:                          "
puts Benchmark.measure { Chronic.parse("jan 3 2010") }

print "7 hours before tomorrow at midnight: "
puts Benchmark.measure { Chronic.parse("7 hours before tomorrow at midnight") }

# n = 100
# Benchmark.bm(14) do |x|
#   x.report("jan 3 2010:")   { for i in 1..n; Chronic.parse("jan 3 2010"); end }
# end
