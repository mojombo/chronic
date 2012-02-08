require 'helper'

class TestRepeaterHour < TestCase

  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_next_future
    hours = Chronic::RepeaterHour.new(:hour)
    hours.start = @now

    next_hour = hours.next(:future)
    assert_equal Time.local(2006, 8, 16, 15), next_hour.begin
    assert_equal Time.local(2006, 8, 16, 16), next_hour.end

    next_next_hour = hours.next(:future)
    assert_equal Time.local(2006, 8, 16, 16), next_next_hour.begin
    assert_equal Time.local(2006, 8, 16, 17), next_next_hour.end
  end

  def test_next_past
    hours = Chronic::RepeaterHour.new(:hour)
    hours.start = @now

    past_hour = hours.next(:past)
    assert_equal Time.local(2006, 8, 16, 13), past_hour.begin
    assert_equal Time.local(2006, 8, 16, 14), past_hour.end

    past_past_hour = hours.next(:past)
    assert_equal Time.local(2006, 8, 16, 12), past_past_hour.begin
    assert_equal Time.local(2006, 8, 16, 13), past_past_hour.end
  end

  def test_this
    @now = Time.local(2006, 8, 16, 14, 30)

    hours = Chronic::RepeaterHour.new(:hour)
    hours.start = @now

    this_hour = hours.this(:future)
    assert_equal Time.local(2006, 8, 16, 14, 31), this_hour.begin
    assert_equal Time.local(2006, 8, 16, 15), this_hour.end

    this_hour = hours.this(:past)
    assert_equal Time.local(2006, 8, 16, 14), this_hour.begin
    assert_equal Time.local(2006, 8, 16, 14, 30), this_hour.end

    this_hour = hours.this(:none)
    assert_equal Time.local(2006, 8, 16, 14), this_hour.begin
    assert_equal Time.local(2006, 8, 16, 15), this_hour.end
  end

  def test_offset
    span = Chronic::Span.new(@now, @now + 1)

    offset_span = Chronic::RepeaterHour.new(:hour).offset(span, 3, :future)

    assert_equal Time.local(2006, 8, 16, 17), offset_span.begin
    assert_equal Time.local(2006, 8, 16, 17, 0, 1), offset_span.end

    offset_span = Chronic::RepeaterHour.new(:hour).offset(span, 24, :past)

    assert_equal Time.local(2006, 8, 15, 14), offset_span.begin
    assert_equal Time.local(2006, 8, 15, 14, 0, 1), offset_span.end
  end

end
