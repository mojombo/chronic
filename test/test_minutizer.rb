require 'helper'


class TestMinutizer < TestCase

  def string(option)
    "test string for #{option}"
  end

  def test_prenormalize
    # half times
    assert_equal "1.5 min",  Chronic::Minutizer.new.pre_normalize("one and a half minutes")
    assert_equal "1.5 min",  Chronic::Minutizer.new.pre_normalize("one and a half minutes")
    assert_equal "1.5 hour",    Chronic::Minutizer.new.pre_normalize("one and a half hours")
    assert_equal "1.5 hour",    Chronic::Minutizer.new.pre_normalize("an hour and a half")
    assert_equal "0.5 hour",    Chronic::Minutizer.new.pre_normalize("half an hour")
    assert_equal "1.5 day",     Chronic::Minutizer.new.pre_normalize("one and a half days")
    assert_equal "0.5 day",     Chronic::Minutizer.new.pre_normalize("half a day")
    assert_equal "sliding for 0.5 hour", Chronic::Minutizer.new.pre_normalize("sliding for half an hour")
    assert_equal "sliding for 2.5 hour", Chronic::Minutizer.new.pre_normalize("sliding for two and a half hours")
    assert_equal "sliding for 0.5 hour", Chronic::Minutizer.new.pre_normalize("sliding for a half hour")
    assert_equal "sliding for 0.5 hour", Chronic::Minutizer.new.pre_normalize("sliding for half an hour")

    #time word variations
    assert_equal "1 sec", Chronic::Minutizer.new.pre_normalize("1 seconds")
    assert_equal "1 sec", Chronic::Minutizer.new.pre_normalize("1 secnds")
    assert_equal "1 sec", Chronic::Minutizer.new.pre_normalize("1 second")
    assert_equal "1 sec", Chronic::Minutizer.new.pre_normalize("1 secnd")
    assert_equal "1 sec", Chronic::Minutizer.new.pre_normalize("1 secs")
    assert_equal "1 sec", Chronic::Minutizer.new.pre_normalize("1 sec")
    assert_equal "1 min", Chronic::Minutizer.new.pre_normalize("1 minutes")
    assert_equal "1 min", Chronic::Minutizer.new.pre_normalize("1 mintues")
    assert_equal "1 min", Chronic::Minutizer.new.pre_normalize("1 mintes")
    assert_equal "1 min", Chronic::Minutizer.new.pre_normalize("1 minute")
    assert_equal "1 min", Chronic::Minutizer.new.pre_normalize("1 mintue")
    assert_equal "1 min", Chronic::Minutizer.new.pre_normalize("1 minte")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("1 horus")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("1 hours")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("1 huors")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("1 huor")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("1 hr")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("1 hrs")
    assert_equal "1 day",    Chronic::Minutizer.new.pre_normalize("1 days")
    assert_equal "1 day",    Chronic::Minutizer.new.pre_normalize("1 day")
    assert_equal "1 day",    Chronic::Minutizer.new.pre_normalize("1 dy")
    assert_equal "1 week",   Chronic::Minutizer.new.pre_normalize("1 weeks")
    assert_equal "1 week",   Chronic::Minutizer.new.pre_normalize("1 wks")
    assert_equal "1 week",   Chronic::Minutizer.new.pre_normalize("1 wk")

    #english numbers
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("an hour")
    assert_equal "1 hour",   Chronic::Minutizer.new.pre_normalize("one hour")
    assert_equal "1.5 hour", Chronic::Minutizer.new.pre_normalize("one and a half hours")
    assert_equal "2 day, 3 hour, and 40 min", Chronic::Minutizer.new.pre_normalize("two days, three hours, and forty minutes")
    assert_equal "2.5 day",  Chronic::Minutizer.new.pre_normalize("two and a half days")
    assert_equal "half the time it 2.5 day", Chronic::Minutizer.new.pre_normalize("half the time it two and a half day")

    # arabic numbers
    assert_equal "1 hour",           Chronic::Minutizer.new.pre_normalize("1 hour")
    assert_equal "1.5 hour",         Chronic::Minutizer.new.pre_normalize("1.5 hours")
    assert_equal "1 hour 30 min", Chronic::Minutizer.new.pre_normalize("1 hour 30 minutes")
    assert_equal "1 hour",           Chronic::Minutizer.new.pre_normalize("1 hour")
    assert_equal "1.5 hour",         Chronic::Minutizer.new.pre_normalize("1 and a half hours")
    assert_equal "1.5 hour",         Chronic::Minutizer.new.pre_normalize("1.5 hours")
    assert_equal "2 day, 3 hour, and 40 min", Chronic::Minutizer.new.pre_normalize("2 days, 3 hours, and 40 minutes")
    assert_equal "2.5 day",          Chronic::Minutizer.new.pre_normalize("2 and a half days")

  end

  def test_extract_time
    assert_equal 60, Chronic::Minutizer.new.extract_time( string "60 minutes" )
    assert_equal 60, Chronic::Minutizer.new.extract_time( string "1 hour" )
    assert_equal 1440, Chronic::Minutizer.new.extract_time( string "1 day" )
    assert_equal 720, Chronic::Minutizer.new.extract_time( string "0.5 day" )
  end

  def test_time_variations
    strings = {
      "hours" => 60,
      "hr" => 60,
      "minutes" => 1,
      "mintue" => 1,
      "half a day" => 2160.0,
      "days" => 1440,
    }
    strings.each do |key, val|
      assert_equal val, Chronic::Minutizer.new.minutize("extracts time for one #{key}")
    end
  end

  def test_no_num_times
    strings = {
      "half a day" => 720,
      "half an hour" => 30,
      "half a minute" => 0.5,
      "a hour" => 60
    }
    strings.each do |key, val|
      assert_equal val, Chronic::Minutizer.new.minutize("extracts time for #{key}")
    end
  end

  def test_mispleled_times
     strings = {
      "60 secnds" => 1,
      "1 minte" => 1,
      "1 mintes" => 1,
      "1 minute" => 1,
      "1 mintue" => 1,
      "1 mintues" => 1,
      "1 huor" => 60,
      "1 huors" => 60,
      "1 dy" => 1440,
      "1 wks" => 10080
    }
    strings.each do |key, val|
      assert_equal val, Chronic::Minutizer.new.minutize("extracts time for #{key}")
    end
  end

  def test_general_text_examples
    assert_equal 5.35, Chronic::Minutizer.new.minutize("The experiment lasted for 321 seconds")
    assert_equal 720, Chronic::Minutizer.new.minutize("I took one sleeping pill and slept for half a day")
    assert_equal 15120.0, Chronic::Minutizer.new.minutize("I was traveling for a week and a half")
    assert_equal 3100, Chronic::Minutizer.new.minutize("I traveled for 2 days, three hrs, and forty mintes")
    assert_equal 20160.0, Chronic::Minutizer.new.minutize("The conference lasted 2 weeks")
  end

  def test_with_mixed_in_numbers
    assert_equal 180, Chronic::Minutizer.new.minutize("I typed 120 lines of code in the last three hours")
    assert_equal 210, Chronic::Minutizer.new.minutize("I drank 15 beers in 3 and a half hours")
    assert_equal 40, Chronic::Minutizer.new.minutize("my three best friends brought half a cake over and we ate it in 40 minutes")
  end

  def test_comma_separated_times
    assert_equal 3100, Chronic::Minutizer.new.minutize("I was traveling for 2 days, three hrs, and forty mintes")
    assert_equal 140, Chronic::Minutizer.new.minutize("it took 2 hours and 20minutes")
  end

  def test_with_mixed_in_time_variations
    assert_equal 180, Chronic::Minutizer.new.minutize("The min requirement to pass is 180 minutes")
    assert_equal 180, Chronic::Minutizer.new.minutize("The second timeto pass is 3 hours")
  end
end