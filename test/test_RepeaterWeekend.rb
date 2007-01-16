require 'chronic'
require 'test/unit'

class TestRepeaterWeekend < Test::Unit::TestCase
  
  def setup
    # Wed Aug 16 14:00:00 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end
  
  def test_next_future
    weekend = Chronic::RepeaterWeekend.new(:weekend)
    weekend.start = @now
    
    next_weekend = weekend.next(:future)
    assert_equal Time.local(2006, 8, 19), next_weekend.begin
    assert_equal Time.local(2006, 8, 21), next_weekend.end
  end
  
  def test_next_past
    weekend = Chronic::RepeaterWeekend.new(:weekend)
    weekend.start = @now
    
    next_weekend = weekend.next(:past)
    assert_equal Time.local(2006, 8, 12), next_weekend.begin
    assert_equal Time.local(2006, 8, 14), next_weekend.end
  end
  
  def test_this_future
    weekend = Chronic::RepeaterWeekend.new(:weekend)
    weekend.start = @now
    
    next_weekend = weekend.this(:future)
    assert_equal Time.local(2006, 8, 19), next_weekend.begin
    assert_equal Time.local(2006, 8, 21), next_weekend.end
  end
  
  def test_this_past
    weekend = Chronic::RepeaterWeekend.new(:weekend)
    weekend.start = @now
    
    next_weekend = weekend.this(:past)
    assert_equal Time.local(2006, 8, 12), next_weekend.begin
    assert_equal Time.local(2006, 8, 14), next_weekend.end
  end
  
  def test_this_none
    weekend = Chronic::RepeaterWeekend.new(:weekend)
    weekend.start = @now
    
    next_weekend = weekend.this(:future)
    assert_equal Time.local(2006, 8, 19), next_weekend.begin
    assert_equal Time.local(2006, 8, 21), next_weekend.end
  end
  
  def test_offset
    span = Chronic::Span.new(@now, @now + 1)
    
    offset_span = Chronic::RepeaterWeekend.new(:weekend).offset(span, 3, :future)
    
    assert_equal Time.local(2006, 9, 2), offset_span.begin
    assert_equal Time.local(2006, 9, 2, 0, 0, 1), offset_span.end
    
    offset_span = Chronic::RepeaterWeekend.new(:weekend).offset(span, 1, :past)
    
    assert_equal Time.local(2006, 8, 12), offset_span.begin
    assert_equal Time.local(2006, 8, 12, 0, 0, 1), offset_span.end
    
    offset_span = Chronic::RepeaterWeekend.new(:weekend).offset(span, 0, :future)
    
    assert_equal Time.local(2006, 8, 12), offset_span.begin
    assert_equal Time.local(2006, 8, 12, 0, 0, 1), offset_span.end
  end
  
end