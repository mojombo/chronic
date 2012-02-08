require 'helper'

class TestRepeaterMonth < TestCase

  def setup
    # Wed Aug 16 14:00:00 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_offset_by
    # future

    time = Chronic::RepeaterMonth.new(:month).offset_by(@now, 1, :future)
    assert_equal Time.local(2006, 9, 16, 14), time

    time = Chronic::RepeaterMonth.new(:month).offset_by(@now, 5, :future)
    assert_equal Time.local(2007, 1, 16, 14), time

    # past

    time = Chronic::RepeaterMonth.new(:month).offset_by(@now, 1, :past)
    assert_equal Time.local(2006, 7, 16, 14), time

    time = Chronic::RepeaterMonth.new(:month).offset_by(@now, 10, :past)
    assert_equal Time.local(2005, 10, 16, 14), time

    time = Chronic::RepeaterMonth.new(:month).offset_by(Time.local(2010, 3, 29), 1, :past)
    assert_equal 2, time.month
    assert_equal 28, time.day
  end

  def test_offset
    # future

    span = Chronic::Span.new(@now, @now + 60)
    offset_span = Chronic::RepeaterMonth.new(:month).offset(span, 1, :future)

    assert_equal Time.local(2006, 9, 16, 14), offset_span.begin
    assert_equal Time.local(2006, 9, 16, 14, 1), offset_span.end

   # past

   span = Chronic::Span.new(@now, @now + 60)
   offset_span = Chronic::RepeaterMonth.new(:month).offset(span, 1, :past)

   assert_equal Time.local(2006, 7, 16, 14), offset_span.begin
   assert_equal Time.local(2006, 7, 16, 14, 1), offset_span.end
  end

end
