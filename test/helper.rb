unless defined? Chronic
  $:.unshift File.expand_path('../../lib', __FILE__)
  require 'chronic'
end

require 'test/unit'