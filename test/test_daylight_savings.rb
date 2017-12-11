require 'helper'

class TestDaylightSavings < TestCase

  def setup
    @begin_daylight_savings = Time.local(2008, 3, 9, 5, 0, 0, 0)
    @end_daylight_savings = Time.local(2008, 11, 2, 5, 0, 0, 0)
  end

  def test_begin_past
    # resolve to last night
    t = Chronic.parse('9:00 PM', :guess => false, :context => :past, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 8, 21), t.begin

    # resolve to this afternoon
    t = Chronic.parse('9:00 PM', :guess => false, :context => :none, :now => Time.local(2008, 3, 9, 22, 0, 0, 0))
    assert_equal Time.local(2008, 3, 9, 21), t.begin

    # resolve to this morning
    t = Chronic.parse('4:00 AM', :guess => false, :context => :none, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 9, 4), t.begin

    # resolve to today
    t = Chronic.parse('04:00', :guess => false, :context => :none, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 9, 4), t.begin

    # resolve to yesterday
    t = Chronic.parse('13:00', :guess => false, :context => :past, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 8, 13), t.begin
  end

  def test_begin_future
    # resolve to this morning
    t = Chronic.parse('9:00 AM', :guess => false, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 9, 9), t.begin

    # resolve to this afternoon
    t = Chronic.parse('9:00 PM', :guess => false, :now => Time.local(2008, 3, 9, 13, 0, 0, 0))
    assert_equal Time.local(2008, 3, 9, 21), t.begin

    # resolve to tomorrow
    t = Chronic.parse('9:00', :guess => false, :now => Time.local(2008, 3, 9, 22, 0, 0, 0))
    assert_equal Time.local(2008, 3, 10, 9), t.begin

    # resolve to today
    t = Chronic.parse('09:00', :guess => false, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 9, 9), t.begin

    # resolve to tomorrow
    t = Chronic.parse('04:00', :guess => false, :now => @begin_daylight_savings)
    assert_equal Time.local(2008, 3, 10, 4), t.begin
  end

  def test_end_past
    # resolve to last night
    t = Chronic.parse('9:00 PM', :guess => false, :context => :past, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 1, 21), t.begin

    # resolve to this afternoon
    t = Chronic.parse('9:00 PM', :guess => false, :context => :none, :now => Time.local(2008, 11, 2, 22, 0, 0, 0))
    assert_equal Time.local(2008, 11, 2, 21), t.begin

    # resolve to this morning
    t = Chronic.parse('4:00', :guess => false, :context => :none, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 2, 4), t.begin

    # resolve to today
    t = Chronic.parse('04:00', :guess => false, :context => :none, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 2, 4), t.begin

    # resolve to yesterday
    t = Chronic.parse('13:00', :guess => false, :context => :past, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 1, 13), t.begin
  end

  def test_end_future
    # resolve to this morning
    t = Chronic.parse('at 9:00', :guess => false, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 2, 9), t.begin

    # resolve to this afternoon
    t = Chronic.parse('9:00 PM', :guess => false, :now => Time.local(2008, 11, 2, 13, 0, 0, 0))
    assert_equal Time.local(2008, 11, 2, 21), t.begin

    # resolve to tomorrow
    t = Chronic.parse('9:00', :guess => false, :now => Time.local(2008, 11, 2, 22, 0, 0, 0))
    assert_equal Time.local(2008, 11, 3, 9), t.begin

    # resolve to today
    t = Chronic.parse('09:00', :guess => false, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 2, 9), t.begin

    # resolve to tomorrow
    t = Chronic.parse('04:00', :guess => false, :now => @end_daylight_savings)
    assert_equal Time.local(2008, 11, 3, 4), t.begin
  end

end
