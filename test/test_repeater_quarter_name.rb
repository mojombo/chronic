require 'helper'

class TestRepeaterQuarterName < TestCase
  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_match
    %w[q1 q2 q3 q4].each do |string|
      token = Chronic::Token.new(string)
      repeater = Chronic::Repeater.scan_for_quarter_names(token)
      assert_equal Chronic::RepeaterQuarterName, repeater.class
      assert_equal string.to_sym, repeater.type
    end
  end

  def test_this_none
    quarter = Chronic::RepeaterQuarterName.new(:q1)
    quarter.start = @now

    time = quarter.this(:none)
    assert_equal Time.local(2006, 1, 1), time.begin
    assert_equal Time.local(2006, 4, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q2)
    quarter.start = @now

    time = quarter.this(:none)
    assert_equal Time.local(2006, 4, 1), time.begin
    assert_equal Time.local(2006, 7, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q3)
    quarter.start = @now

    time = quarter.this(:none)
    assert_equal Time.local(2006, 7, 1), time.begin
    assert_equal Time.local(2006, 10, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q4)
    quarter.start = @now

    time = quarter.this(:none)
    assert_equal Time.local(2006, 10, 1), time.begin
    assert_equal Time.local(2007, 1, 1), time.end
  end

  def test_this_past
    quarter = Chronic::RepeaterQuarterName.new(:q1)
    quarter.start = @now

    time = quarter.this(:past)
    assert_equal Time.local(2006, 1, 1), time.begin
    assert_equal Time.local(2006, 4, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q2)
    quarter.start = @now

    time = quarter.this(:past)
    assert_equal Time.local(2006, 4, 1), time.begin
    assert_equal Time.local(2006, 7, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q3)
    quarter.start = @now

    time = quarter.this(:past)
    assert_equal Time.local(2005, 7, 1), time.begin
    assert_equal Time.local(2005, 10, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q4)
    quarter.start = @now

    time = quarter.this(:past)
    assert_equal Time.local(2005, 10, 1), time.begin
    assert_equal Time.local(2006, 1, 1), time.end
  end

  def test_this_future
    quarter = Chronic::RepeaterQuarterName.new(:q1)
    quarter.start = @now

    time = quarter.this(:future)
    assert_equal Time.local(2007, 1, 1), time.begin
    assert_equal Time.local(2007, 4, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q2)
    quarter.start = @now

    time = quarter.this(:future)
    assert_equal Time.local(2007, 4, 1), time.begin
    assert_equal Time.local(2007, 7, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q3)
    quarter.start = @now

    time = quarter.this(:future)
    assert_equal Time.local(2007, 7, 1), time.begin
    assert_equal Time.local(2007, 10, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q4)
    quarter.start = @now

    time = quarter.this(:future)
    assert_equal Time.local(2006, 10, 1), time.begin
    assert_equal Time.local(2007, 1, 1), time.end
  end

  def test_next_future
    quarter = Chronic::RepeaterQuarterName.new(:q1)
    quarter.start = @now

    time = quarter.next(:future)
    assert_equal Time.local(2007, 1, 1), time.begin
    assert_equal Time.local(2007, 4, 1), time.end

    time = quarter.next(:future)
    assert_equal Time.local(2008, 1, 1), time.begin
    assert_equal Time.local(2008, 4, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q2)
    quarter.start = @now

    time = quarter.next(:future)
    assert_equal Time.local(2007, 4, 1), time.begin
    assert_equal Time.local(2007, 7, 1), time.end

    time = quarter.next(:future)
    assert_equal Time.local(2008, 4, 1), time.begin
    assert_equal Time.local(2008, 7, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q3)
    quarter.start = @now

    time = quarter.next(:future)
    assert_equal Time.local(2007, 7, 1), time.begin
    assert_equal Time.local(2007, 10, 1), time.end

    time = quarter.next(:future)
    assert_equal Time.local(2008, 7, 1), time.begin
    assert_equal Time.local(2008, 10, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q4)
    quarter.start = @now

    time = quarter.next(:future)
    assert_equal Time.local(2006, 10, 1), time.begin
    assert_equal Time.local(2007, 1, 1), time.end

    time = quarter.next(:future)
    assert_equal Time.local(2007, 10, 1), time.begin
    assert_equal Time.local(2008, 1, 1), time.end
  end

  def test_next_past
    quarter = Chronic::RepeaterQuarterName.new(:q1)
    quarter.start = @now

    time = quarter.next(:past)
    assert_equal Time.local(2006, 1, 1), time.begin
    assert_equal Time.local(2006, 4, 1), time.end

    time = quarter.next(:past)
    assert_equal Time.local(2005, 1, 1), time.begin
    assert_equal Time.local(2005, 4, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q2)
    quarter.start = @now

    time = quarter.next(:past)
    assert_equal Time.local(2006, 4, 1), time.begin
    assert_equal Time.local(2006, 7, 1), time.end

    time = quarter.next(:past)
    assert_equal Time.local(2005, 4, 1), time.begin
    assert_equal Time.local(2005, 7, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q3)
    quarter.start = @now

    time = quarter.next(:past)
    assert_equal Time.local(2005, 7, 1), time.begin
    assert_equal Time.local(2005, 10, 1), time.end

    time = quarter.next(:past)
    assert_equal Time.local(2004, 7, 1), time.begin
    assert_equal Time.local(2004, 10, 1), time.end

    quarter = Chronic::RepeaterQuarterName.new(:q4)
    quarter.start = @now

    time = quarter.next(:past)
    assert_equal Time.local(2005, 10, 1), time.begin
    assert_equal Time.local(2006, 1, 1), time.end

    time = quarter.next(:past)
    assert_equal Time.local(2004, 10, 1), time.begin
    assert_equal Time.local(2005, 1, 1), time.end
  end
end
