require 'helper'

class TestRepeaterTime < Test::Unit::TestCase

  def setup
    # Wed Aug 16 14:00:00 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_next_future
    t = Chronic::RepeaterTime.new('4:00')
    t.start = @now

    assert_equal Time.local(2006, 8, 16, 16), t.next(:future).begin
    assert_equal Time.local(2006, 8, 17, 4), t.next(:future).begin

    t = Chronic::RepeaterTime.new('13:00')
    t.start = @now

    assert_equal Time.local(2006, 8, 17, 13), t.next(:future).begin
    assert_equal Time.local(2006, 8, 18, 13), t.next(:future).begin

    t = Chronic::RepeaterTime.new('0400')
    t.start = @now

    assert_equal Time.local(2006, 8, 17, 4), t.next(:future).begin
    assert_equal Time.local(2006, 8, 18, 4), t.next(:future).begin
  end

  def test_next_past
    t = Chronic::RepeaterTime.new('4:00')
    t.start = @now

    assert_equal Time.local(2006, 8, 16, 4), t.next(:past).begin
    assert_equal Time.local(2006, 8, 15, 16), t.next(:past).begin

    t = Chronic::RepeaterTime.new('13:00')
    t.start = @now

    assert_equal Time.local(2006, 8, 16, 13), t.next(:past).begin
    assert_equal Time.local(2006, 8, 15, 13), t.next(:past).begin
  end

  def test_type
    t1 = Chronic::RepeaterTime.new('4')
    assert_equal 14_400, t1.type.time

    t1 = Chronic::RepeaterTime.new('14')
    assert_equal 50_400, t1.type.time

    t1 = Chronic::RepeaterTime.new('4:00')
    assert_equal 14_400, t1.type.time

    t1 = Chronic::RepeaterTime.new('4:30')
    assert_equal 16_200, t1.type.time

    t1 = Chronic::RepeaterTime.new('1400')
    assert_equal 50_400, t1.type.time

    t1 = Chronic::RepeaterTime.new('0400')
    assert_equal 14_400, t1.type.time

    t1 = Chronic::RepeaterTime.new('04')
    assert_equal 14_400, t1.type.time

    t1 = Chronic::RepeaterTime.new('400')
    assert_equal 14_400, t1.type.time
  end

end
