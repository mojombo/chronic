require 'helper'

class TestDaylightSavings < Test::Unit::TestCase

  def setup
    @begin_daylight_savings = Time.local(2008, 3, 9, 5, 0, 0, 0)
    @end_daylight_savings = Time.local(2008, 11, 2, 5, 0, 0, 0)
  end

  def test_begin_past
    # ambiguous - resolve to last night
    t = Chronic::RepeaterTime.new('900')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 8, 21), t.next(:past).begin

    # ambiguous - resolve to this afternoon
    t = Chronic::RepeaterTime.new('900')
    t.start = Time.local(2008, 3, 9, 22, 0, 0, 0)
    assert_equal Time.local(2008, 3, 9, 21), t.next(:past).begin

    # ambiguous - resolve to this morning
    t = Chronic::RepeaterTime.new('400')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 9, 4), t.next(:past).begin

    # unambiguous - resolve to today
    t = Chronic::RepeaterTime.new('0400')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 9, 4), t.next(:past).begin

    # unambiguous - resolve to yesterday
    t = Chronic::RepeaterTime.new('1300')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 8, 13), t.next(:past).begin
  end

  def test_begin_future
    # ambiguous - resolve to this morning
    t = Chronic::RepeaterTime.new('900')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 9, 9), t.next(:future).begin

    # ambiguous - resolve to this afternoon
    t = Chronic::RepeaterTime.new('900')
    t.start = Time.local(2008, 3, 9, 13, 0, 0, 0)
    assert_equal Time.local(2008, 3, 9, 21), t.next(:future).begin

    # ambiguous - resolve to tomorrow
    t = Chronic::RepeaterTime.new('900')
    t.start = Time.local(2008, 3, 9, 22, 0, 0, 0)
    assert_equal Time.local(2008, 3, 10, 9), t.next(:future).begin

    # unambiguous - resolve to today
    t = Chronic::RepeaterTime.new('0900')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 9, 9), t.next(:future).begin

    # unambiguous - resolve to tomorrow
    t = Chronic::RepeaterTime.new('0400')
    t.start = @begin_daylight_savings
    assert_equal Time.local(2008, 3, 10, 4), t.next(:future).begin
  end

  def test_end_past
    # ambiguous - resolve to last night
    t = Chronic::RepeaterTime.new('900')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 1, 21), t.next(:past).begin

    # ambiguous - resolve to this afternoon
    t = Chronic::RepeaterTime.new('900')
    t.start = Time.local(2008, 11, 2, 22, 0, 0, 0)
    assert_equal Time.local(2008, 11, 2, 21), t.next(:past).begin

    # ambiguous - resolve to this morning
    t = Chronic::RepeaterTime.new('400')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 2, 4), t.next(:past).begin

    # unambiguous - resolve to today
    t = Chronic::RepeaterTime.new('0400')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 2, 4), t.next(:past).begin

    # unambiguous - resolve to yesterday
    t = Chronic::RepeaterTime.new('1300')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 1, 13), t.next(:past).begin
  end

  def test_end_future
    # ambiguous - resolve to this morning
    t = Chronic::RepeaterTime.new('900')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 2, 9), t.next(:future).begin

    # ambiguous - resolve to this afternoon
    t = Chronic::RepeaterTime.new('900')
    t.start = Time.local(2008, 11, 2, 13, 0, 0, 0)
    assert_equal Time.local(2008, 11, 2, 21), t.next(:future).begin

    # ambiguous - resolve to tomorrow
    t = Chronic::RepeaterTime.new('900')
    t.start = Time.local(2008, 11, 2, 22, 0, 0, 0)
    assert_equal Time.local(2008, 11, 3, 9), t.next(:future).begin

    # unambiguous - resolve to today
    t = Chronic::RepeaterTime.new('0900')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 2, 9), t.next(:future).begin

    # unambiguous - resolve to tomorrow
    t = Chronic::RepeaterTime.new('0400')
    t.start = @end_daylight_savings
    assert_equal Time.local(2008, 11, 3, 4), t.next(:future).begin
  end

end
