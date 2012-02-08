require 'helper'

class TestRepeaterWeekday < Test::Unit::TestCase

  def setup
    @now = Time.local(2007, 6, 11, 14, 0, 0, 0) # Mon
  end

  def test_next_future
    weekdays = Chronic::RepeaterWeekday.new(:weekday)
    weekdays.start = @now

    next1_weekday = weekdays.next(:future) # Tues
    assert_equal Time.local(2007, 6, 12), next1_weekday.begin
    assert_equal Time.local(2007, 6, 13), next1_weekday.end

    next2_weekday = weekdays.next(:future) # Wed
    assert_equal Time.local(2007, 6, 13), next2_weekday.begin
    assert_equal Time.local(2007, 6, 14), next2_weekday.end

    next3_weekday = weekdays.next(:future) # Thurs
    assert_equal Time.local(2007, 6, 14), next3_weekday.begin
    assert_equal Time.local(2007, 6, 15), next3_weekday.end

    next4_weekday = weekdays.next(:future) # Fri
    assert_equal Time.local(2007, 6, 15), next4_weekday.begin
    assert_equal Time.local(2007, 6, 16), next4_weekday.end

    next5_weekday = weekdays.next(:future) # Mon
    assert_equal Time.local(2007, 6, 18), next5_weekday.begin
    assert_equal Time.local(2007, 6, 19), next5_weekday.end
  end

  def test_next_past
    weekdays = Chronic::RepeaterWeekday.new(:weekday)
    weekdays.start = @now

    last1_weekday = weekdays.next(:past) # Fri
    assert_equal Time.local(2007, 6, 8), last1_weekday.begin
    assert_equal Time.local(2007, 6, 9), last1_weekday.end

    last2_weekday = weekdays.next(:past) # Thurs
    assert_equal Time.local(2007, 6, 7), last2_weekday.begin
    assert_equal Time.local(2007, 6, 8), last2_weekday.end
  end

  def test_offset
    span = Chronic::Span.new(@now, @now + 1)

    offset_span = Chronic::RepeaterWeekday.new(:weekday).offset(span, 5, :future)

    assert_equal Time.local(2007, 6, 18, 14), offset_span.begin
    assert_equal Time.local(2007, 6, 18, 14, 0, 1), offset_span.end
  end
end
