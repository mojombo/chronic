require 'helper'

class TestRepeaterDayPortion < TestCase

  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end
  
  def test_am_future
    day_portion = Chronic::RepeaterDayPortion.new(:am)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 17, 00), next_time.begin
    assert_equal Time.local(2006, 8, 17, 11, 59, 59), next_time.end

    next_next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 18, 00), next_next_time.begin
    assert_equal Time.local(2006, 8, 18, 11, 59, 59), next_next_time.end
  end

  def test_am_past
    day_portion = Chronic::RepeaterDayPortion.new(:am)
    day_portion.start = @now
    
    next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 16, 00), next_time.begin
    assert_equal Time.local(2006, 8, 16, 11, 59, 59), next_time.end

    next_next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 15, 00), next_next_time.begin
    assert_equal Time.local(2006, 8, 15, 11, 59, 59), next_next_time.end
  end
  
  def test_am_future_with_daylight_savings_time_boundary
    @now = Time.local(2012,11,3,0,0,0)
    day_portion = Chronic::RepeaterDayPortion.new(:am)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2012, 11, 4, 00), next_time.begin
    assert_equal Time.local(2012, 11, 4, 11, 59, 59), next_time.end

    next_next_time = day_portion.next(:future)

    assert_equal Time.local(2012, 11, 5, 00), next_next_time.begin
    assert_equal Time.local(2012, 11, 5, 11, 59, 59), next_next_time.end
  end

  def test_pm_future
    day_portion = Chronic::RepeaterDayPortion.new(:pm)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 17, 12), next_time.begin
    assert_equal Time.local(2006, 8, 17, 23, 59, 59), next_time.end

    next_next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 18, 12), next_next_time.begin
    assert_equal Time.local(2006, 8, 18, 23, 59, 59), next_next_time.end
  end

  def test_pm_past
    day_portion = Chronic::RepeaterDayPortion.new(:pm)
    day_portion.start = @now
    
    next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 15, 12), next_time.begin
    assert_equal Time.local(2006, 8, 15, 23, 59, 59), next_time.end

    next_next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 14, 12), next_next_time.begin
    assert_equal Time.local(2006, 8, 14, 23, 59, 59), next_next_time.end
  end
  
  def test_pm_future_with_daylight_savings_time_boundary
    @now = Time.local(2012,11,3,0,0,0)
    day_portion = Chronic::RepeaterDayPortion.new(:pm)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2012, 11, 3, 12), next_time.begin
    assert_equal Time.local(2012, 11, 3, 23, 59, 59), next_time.end

    next_next_time = day_portion.next(:future)

    assert_equal Time.local(2012, 11, 4, 12), next_next_time.begin
    assert_equal Time.local(2012, 11, 4, 23, 59, 59), next_next_time.end
  end

  def test_morning_future
    day_portion = Chronic::RepeaterDayPortion.new(:morning)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 17, 6), next_time.begin
    assert_equal Time.local(2006, 8, 17, 12), next_time.end

    next_next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 18, 6), next_next_time.begin
    assert_equal Time.local(2006, 8, 18, 12), next_next_time.end
  end

  def test_morning_past
    day_portion = Chronic::RepeaterDayPortion.new(:morning)
    day_portion.start = @now
    
    next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 16, 6), next_time.begin
    assert_equal Time.local(2006, 8, 16, 12), next_time.end

    next_next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 15, 6), next_next_time.begin
    assert_equal Time.local(2006, 8, 15, 12), next_next_time.end
  end
  
  def test_morning_future_with_daylight_savings_time_boundary
    @now = Time.local(2012,11,3,0,0,0)
    day_portion = Chronic::RepeaterDayPortion.new(:morning)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2012, 11, 3, 6), next_time.begin
    assert_equal Time.local(2012, 11, 3, 12), next_time.end

    next_next_time = day_portion.next(:future)

    assert_equal Time.local(2012, 11, 4, 6), next_next_time.begin
    assert_equal Time.local(2012, 11, 4, 12), next_next_time.end
  end

  def test_afternoon_future
    day_portion = Chronic::RepeaterDayPortion.new(:afternoon)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 17, 13), next_time.begin
    assert_equal Time.local(2006, 8, 17, 17), next_time.end

    next_next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 18, 13), next_next_time.begin
    assert_equal Time.local(2006, 8, 18, 17), next_next_time.end
  end

  def test_afternoon_past
    day_portion = Chronic::RepeaterDayPortion.new(:afternoon)
    day_portion.start = @now
    
    next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 15, 13), next_time.begin
    assert_equal Time.local(2006, 8, 15, 17), next_time.end

    next_next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 14, 13), next_next_time.begin
    assert_equal Time.local(2006, 8, 14, 17), next_next_time.end
  end
  
  def test_afternoon_future_with_daylight_savings_time_boundary
    @now = Time.local(2012,11,3,0,0,0)
    day_portion = Chronic::RepeaterDayPortion.new(:afternoon)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2012, 11, 3, 13), next_time.begin
    assert_equal Time.local(2012, 11, 3, 17), next_time.end

    next_next_time = day_portion.next(:future)

    assert_equal Time.local(2012, 11, 4, 13), next_next_time.begin
    assert_equal Time.local(2012, 11, 4, 17), next_next_time.end
  end

  def test_evening_future
    day_portion = Chronic::RepeaterDayPortion.new(:evening)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 16, 17), next_time.begin
    assert_equal Time.local(2006, 8, 16, 20), next_time.end

    next_next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 17, 17), next_next_time.begin
    assert_equal Time.local(2006, 8, 17, 20), next_next_time.end
  end

  def test_evening_past
    day_portion = Chronic::RepeaterDayPortion.new(:evening)
    day_portion.start = @now
    
    next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 15, 17), next_time.begin
    assert_equal Time.local(2006, 8, 15, 20), next_time.end

    next_next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 14, 17), next_next_time.begin
    assert_equal Time.local(2006, 8, 14, 20), next_next_time.end
  end
  
  def test_evening_future_with_daylight_savings_time_boundary
    @now = Time.local(2012,11,3,0,0,0)
    day_portion = Chronic::RepeaterDayPortion.new(:evening)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2012, 11, 3, 17), next_time.begin
    assert_equal Time.local(2012, 11, 3, 20), next_time.end

    next_next_time = day_portion.next(:future)

    assert_equal Time.local(2012, 11, 4, 17), next_next_time.begin
    assert_equal Time.local(2012, 11, 4, 20), next_next_time.end
  end

  def test_night_future
    day_portion = Chronic::RepeaterDayPortion.new(:night)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 16, 20), next_time.begin
    assert_equal Time.local(2006, 8, 17, 0), next_time.end

    next_next_time = day_portion.next(:future)
    assert_equal Time.local(2006, 8, 17, 20), next_next_time.begin
    assert_equal Time.local(2006, 8, 18, 0), next_next_time.end
  end

  def test_night_past
    day_portion = Chronic::RepeaterDayPortion.new(:night)
    day_portion.start = @now
    
    next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 15, 20), next_time.begin
    assert_equal Time.local(2006, 8, 16, 0), next_time.end

    next_next_time = day_portion.next(:past)
    assert_equal Time.local(2006, 8, 14, 20), next_next_time.begin
    assert_equal Time.local(2006, 8, 15, 0), next_next_time.end
  end
  
  def test_night_future_with_daylight_savings_time_boundary
    @now = Time.local(2012,11,3,0,0,0)
    day_portion = Chronic::RepeaterDayPortion.new(:night)
    day_portion.start = @now
    
    next_time = day_portion.next(:future)
    assert_equal Time.local(2012, 11, 3, 20), next_time.begin
    assert_equal Time.local(2012, 11, 4, 0), next_time.end

    next_next_time = day_portion.next(:future)

    assert_equal Time.local(2012, 11, 4, 20), next_next_time.begin
    assert_equal Time.local(2012, 11, 5, 0), next_next_time.end
  end
end
