unless defined? Chronic
  $:.unshift File.expand_path('../../lib', __FILE__)
  require 'chronic'
end

require 'minitest/autorun'

class TestCase < MiniTest::Test
  def self.test(name, &block)
    define_method("test_#{name.gsub(/\W/, '_')}", &block) if block
  end
end
