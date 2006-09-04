require 'chronic'
require 'test/unit'

class TestSpan < Test::Unit::TestCase
  
  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_span_width
    span = Chronic::Span.new(Time.local(2006, 8, 16, 0), Time.local(2006, 8, 17, 0))
    assert_equal (60 * 60 * 24), span.width
  end
  
  def test_span_math
    s = Chronic::Span.new(1, 2)
    assert_equal 2, (s + 1).begin
    assert_equal 3, (s + 1).end
    assert_equal 0, (s - 1).begin
    assert_equal 1, (s - 1).end
  end
  
end