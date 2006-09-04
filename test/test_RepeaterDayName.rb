require 'chronic'
require 'test/unit'

class TestRepeaterDayName < Test::Unit::TestCase
  
  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end
  
  def test_match
    token = Chronic::Token.new('saturday')
    repeater = Chronic::Repeater.scan_for_day_names(token)
    assert_equal Chronic::RepeaterDayName, repeater.class
    assert_equal :saturday, repeater.type
    
    token = Chronic::Token.new('sunday')
    repeater = Chronic::Repeater.scan_for_day_names(token)
    assert_equal Chronic::RepeaterDayName, repeater.class
    assert_equal :sunday, repeater.type
  end

  def test_next_future
    mondays = Chronic::RepeaterDayName.new(:monday)
    mondays.start = @now
    
    span = mondays.next(:future)
    
    assert_equal Time.local(2006, 8, 21), span.begin
    assert_equal Time.local(2006, 8, 22), span.end 

    span = mondays.next(:future)
    
    assert_equal Time.local(2006, 8, 28), span.begin
    assert_equal Time.local(2006, 8, 29), span.end
  end
  
  def test_next_past
    mondays = Chronic::RepeaterDayName.new(:monday)
    mondays.start = @now
    
    span = mondays.next(:past)
    
    assert_equal Time.local(2006, 8, 14), span.begin
    assert_equal Time.local(2006, 8, 15), span.end 

    span = mondays.next(:past)
    
    assert_equal Time.local(2006, 8, 7), span.begin
    assert_equal Time.local(2006, 8, 8), span.end
  end
  
end