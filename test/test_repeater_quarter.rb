require 'helper'

class TestRepeaterQuarter < TestCase
  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_match
    token = Chronic::Token.new('Q')
    repeater = Chronic::Repeater.scan_for_units(token)
    assert_equal Chronic::RepeaterQuarter, repeater.class
    assert_equal :quarter, repeater.type
  end

  def test_this
    quarter = Chronic::RepeaterQuarter.new(:quarter)
    quarter.start = @now

    time = quarter.this
    assert_equal Time.local(2006, 7, 1), time.begin
    assert_equal Time.local(2006, 10, 1), time.end
  end

  def test_next_future
    quarter = Chronic::RepeaterQuarter.new(:quarter)
    quarter.start = @now

    time = quarter.next(:future)
    assert_equal Time.local(2006, 10, 1), time.begin
    assert_equal Time.local(2007, 1, 1), time.end

    time = quarter.next(:future)
    assert_equal Time.local(2007, 1, 1), time.begin
    assert_equal Time.local(2007, 4, 1), time.end

    time = quarter.next(:future)
    assert_equal Time.local(2007, 4, 1), time.begin
    assert_equal Time.local(2007, 7, 1), time.end
  end

  def test_next_past
    quarter = Chronic::RepeaterQuarter.new(:quarter)
    quarter.start = @now

    time = quarter.next(:past)
    assert_equal Time.local(2006, 4, 1), time.begin
    assert_equal Time.local(2006, 7, 1), time.end

    time = quarter.next(:past)
    assert_equal Time.local(2006, 1, 1), time.begin
    assert_equal Time.local(2006, 4, 1), time.end

    time = quarter.next(:past)
    assert_equal Time.local(2005, 10, 1), time.begin
    assert_equal Time.local(2006, 1, 1), time.end
  end

  def test_offset
    quarter = Chronic::RepeaterQuarter.new(:quarter)
    span = Chronic::Span.new(@now, @now + 1)

    time = quarter.offset(span, 1, :future)
    assert_equal Time.local(2006, 10, 1), time.begin
    assert_equal Time.local(2007, 1, 1), time.end

    time = quarter.offset(span, 1, :past)
    assert_equal Time.local(2006, 4, 1), time.begin
    assert_equal Time.local(2006, 7, 1), time.end
  end
end
