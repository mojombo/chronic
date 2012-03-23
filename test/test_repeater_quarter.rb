require 'helper'

class TestRepeaterQuarter < TestCase

  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_next_future
    quarters = Chronic::RepeaterQuarter.new(:quarter)
    quarters.start = @now

    next_quarter = quarters.next(:future)
    assert_equal Time.local(2006, 10, 1), next_quarter.begin
    assert_equal Time.local(2006, 12,31), next_quarter.end
  end

  def text_next_past
    quarters = Chronic::RepeaterQuarter.new(:quarter)
    quarters.start = @now

    last_quarter = quarters.next(:past)
    assert_equal Time.local(2006, 4, 1), last_quarter.begin
    assert_equal Time.local(2006, 6, 30), last_quarter.end
  end

  def test_this
    quarters = Chronic::RepeaterQuarter.new(:quarter)
    quarters.start = @now

    this_quarter = quarters.this(:future)
    assert_equal Time.local(2006, 8, 17), this_quarter.begin
    assert_equal Time.local(2006, 9, 30), this_quarter.end

    this_quarter = quarters.this(:past)
    assert_equal Time.local(2006, 7, 1), this_quarter.begin
    assert_equal Time.local(2006, 8, 16), this_quarter.end
  end

end