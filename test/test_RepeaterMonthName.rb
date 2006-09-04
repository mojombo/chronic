require 'chronic'
require 'test/unit'

class TestRepeaterMonthName < Test::Unit::TestCase
  
  def setup
    # Wed Aug 16 14:00:00 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end
  
  def test_next
    # future
    
    mays = Chronic::RepeaterMonthName.new(:may)
    mays.start = @now
    
    next_may = mays.next(:future)
    assert_equal Time.local(2007, 5), next_may.begin
    assert_equal Time.local(2007, 6), next_may.end
    
    next_next_may = mays.next(:future)
    assert_equal Time.local(2008, 5), next_next_may.begin
    assert_equal Time.local(2008, 6), next_next_may.end
    
    decembers = Chronic::RepeaterMonthName.new(:december)
    decembers.start = @now
    
    next_december = decembers.next(:future)
    assert_equal Time.local(2006, 12), next_december.begin
    assert_equal Time.local(2007, 1), next_december.end
    
    # past
    
    mays = Chronic::RepeaterMonthName.new(:may)
    mays.start = @now
    
    assert_equal Time.local(2006, 5), mays.next(:past).begin
    assert_equal Time.local(2005, 5), mays.next(:past).begin
  end
  
  def test_this
    octobers = Chronic::RepeaterMonthName.new(:october)
    octobers.start = @now
    
    this_october = octobers.this(:future)
    assert_equal Time.local(2006, 10, 1), this_october.begin
    assert_equal Time.local(2006, 11, 1), this_october.end
    
    aprils = Chronic::RepeaterMonthName.new(:april)
    aprils.start = @now
    
    this_april = aprils.this(:past)
    assert_equal Time.local(2006, 4, 1), this_april.begin
    assert_equal Time.local(2006, 5, 1), this_april.end
  end
  
end