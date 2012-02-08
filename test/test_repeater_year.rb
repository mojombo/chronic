require 'helper'

class TestRepeaterYear < TestCase

  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_next_future
    years = Chronic::RepeaterYear.new(:year)
    years.start = @now

    next_year = years.next(:future)
    assert_equal Time.local(2007, 1, 1), next_year.begin
    assert_equal Time.local(2008, 1, 1), next_year.end

    next_next_year = years.next(:future)
    assert_equal Time.local(2008, 1, 1), next_next_year.begin
    assert_equal Time.local(2009, 1, 1), next_next_year.end
  end

  def test_next_past
    years = Chronic::RepeaterYear.new(:year)
    years.start = @now

    last_year = years.next(:past)
    assert_equal Time.local(2005, 1, 1), last_year.begin
    assert_equal Time.local(2006, 1, 1), last_year.end

    last_last_year = years.next(:past)
    assert_equal Time.local(2004, 1, 1), last_last_year.begin
    assert_equal Time.local(2005, 1, 1), last_last_year.end
  end

  def test_this
    years = Chronic::RepeaterYear.new(:year)
    years.start = @now

    this_year = years.this(:future)
    assert_equal Time.local(2006, 8, 17), this_year.begin
    assert_equal Time.local(2007, 1, 1), this_year.end

    this_year = years.this(:past)
    assert_equal Time.local(2006, 1, 1), this_year.begin
    assert_equal Time.local(2006, 8, 16), this_year.end
  end

  def test_offset
    span = Chronic::Span.new(@now, @now + 1)

    offset_span = Chronic::RepeaterYear.new(:year).offset(span, 3, :future)

    assert_equal Time.local(2009, 8, 16, 14), offset_span.begin
    assert_equal Time.local(2009, 8, 16, 14, 0, 1), offset_span.end

    offset_span = Chronic::RepeaterYear.new(:year).offset(span, 10, :past)

    assert_equal Time.local(1996, 8, 16, 14), offset_span.begin
    assert_equal Time.local(1996, 8, 16, 14, 0, 1), offset_span.end

    now = Time.local(2008, 2, 29)
    span = Chronic::Span.new(now, now + 1)
    offset_span = Chronic::RepeaterYear.new(:year).offset(span, 1, :past)

    assert_equal Time.local(2007, 2, 28), offset_span.begin
    assert_equal Time.local(2007, 2, 28, 0, 0, 1), offset_span.end
  end

end
