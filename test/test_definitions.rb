require 'helper'

class TestDefinitions < TestCase

  def setup
  end

  # DayName, MonthName ScalarDay, ScalarYear
  def test_dn_mn_sd_sy
    time = Chronic.parse('Wed Sep 27 2017', :guess => false)
    assert_equal Time.local(2017, 9, 27, 0), time.begin
    assert_equal Time.local(2017, 9, 28, 0), time.end

    time = Chronic.parse('Wed, Sep 27, 2017', :guess => false)
    assert_equal Time.local(2017, 9, 27, 0), time.begin
    assert_equal Time.local(2017, 9, 28, 0), time.end
  end

  # DayName, MonthName OrdinalDay, ScalarYear
  def test_dn_mn_od_sy
    time = Chronic.parse('Sun Oct 22nd 2017', :guess => false)
    assert_equal Time.local(2017, 10, 22, 0), time.begin
    assert_equal Time.local(2017, 10, 23, 0), time.end

    time = Chronic.parse('Mon Oct 30th 2017', :guess => false)
    assert_equal Time.local(2017, 10, 30, 0), time.begin
    assert_equal Time.local(2017, 10, 31, 0), time.end

    time = Chronic.parse('Sun, Oct 22nd, 2017', :guess => false)
    assert_equal Time.local(2017, 10, 22, 0), time.begin
    assert_equal Time.local(2017, 10, 23, 0), time.end

    time = Chronic.parse('Mon, Oct 30th, 2017', :guess => false)
    assert_equal Time.local(2017, 10, 30, 0), time.begin
    assert_equal Time.local(2017, 10, 31, 0), time.end

  end

end

