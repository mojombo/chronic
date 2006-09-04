require 'chronic'
require 'test/unit'

class TestRepeaterWeek < Test::Unit::TestCase
  
  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_next_future
    weeks = Chronic::RepeaterWeek.new(:week)
    weeks.start = @now
    
    next_week = weeks.next(:future)
    assert_equal Time.local(2006, 8, 20), next_week.begin
    assert_equal Time.local(2006, 8, 27), next_week.end
    
    next_next_week = weeks.next(:future)
    assert_equal Time.local(2006, 8, 27), next_next_week.begin
    assert_equal Time.local(2006, 9, 3), next_next_week.end
  end
  
  def test_next_past
    weeks = Chronic::RepeaterWeek.new(:week)
    weeks.start = @now
    
    last_week = weeks.next(:past)
    assert_equal Time.local(2006, 8, 6), last_week.begin
    assert_equal Time.local(2006, 8, 13), last_week.end
    
    last_last_week = weeks.next(:past)
    assert_equal Time.local(2006, 7, 30), last_last_week.begin
    assert_equal Time.local(2006, 8, 6), last_last_week.end
  end
  
  def test_this_future
    weeks = Chronic::RepeaterWeek.new(:week)
    weeks.start = @now
    
    this_week = weeks.this(:future)
    assert_equal Time.local(2006, 8, 16, 15), this_week.begin
    assert_equal Time.local(2006, 8, 20), this_week.end
  end
  
  def test_this_past
    weeks = Chronic::RepeaterWeek.new(:week)
    weeks.start = @now
    
    this_week = weeks.this(:past)
    assert_equal Time.local(2006, 8, 13, 0), this_week.begin
    assert_equal Time.local(2006, 8, 16, 14), this_week.end
  end
  
  def test_offset
    span = Chronic::Span.new(@now, @now + 1)
    
    offset_span = Chronic::RepeaterWeek.new(:week).offset(span, 3, :future)
    
    assert_equal Time.local(2006, 9, 6, 14), offset_span.begin
    assert_equal Time.local(2006, 9, 6, 14, 0, 1), offset_span.end
  end
  
end