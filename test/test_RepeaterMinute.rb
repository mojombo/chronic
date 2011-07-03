require 'helper'

class TestRepeaterMinute < Test::Unit::TestCase

  def setup
    @now = Time.local(2008, 6, 25, 7, 15, 30, 0)
  end

  def test_next_future
    minutes = Chronic::RepeaterMinute.new(:minute)
    minutes.start = @now

    next_minute = minutes.next(:future)
    assert_equal Time.local(2008, 6, 25, 7, 16), next_minute.begin
    assert_equal Time.local(2008, 6, 25, 7, 17), next_minute.end

    next_next_minute = minutes.next(:future)
    assert_equal Time.local(2008, 6, 25, 7, 17), next_next_minute.begin
    assert_equal Time.local(2008, 6, 25, 7, 18), next_next_minute.end
  end

  def test_next_past
    minutes = Chronic::RepeaterMinute.new(:minute)
    minutes.start = @now

    prev_minute = minutes.next(:past)
    assert_equal Time.local(2008, 6, 25, 7, 14), prev_minute.begin
    assert_equal Time.local(2008, 6, 25, 7, 15), prev_minute.end

    prev_prev_minute = minutes.next(:past)
    assert_equal Time.local(2008, 6, 25, 7, 13), prev_prev_minute.begin
    assert_equal Time.local(2008, 6, 25, 7, 14), prev_prev_minute.end
  end
end
