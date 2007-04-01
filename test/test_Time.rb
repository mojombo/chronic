require 'chronic'
require 'test/unit'

class TestTime < Test::Unit::TestCase
  
  def setup
  end
  
  def test_normal
    assert_equal Time.local(2006, 1, 2, 0, 0, 0), Time.construct(2006, 1, 2, 0, 0, 0)
    assert_equal Time.local(2006, 1, 2, 3, 0, 0), Time.construct(2006, 1, 2, 3, 0, 0)
    assert_equal Time.local(2006, 1, 2, 3, 4, 0), Time.construct(2006, 1, 2, 3, 4, 0)
    assert_equal Time.local(2006, 1, 2, 3, 4, 5), Time.construct(2006, 1, 2, 3, 4, 5)
  end
  
  def test_second_overflow
    assert_equal Time.local(2006, 1, 1, 0, 1, 30), Time.construct(2006, 1, 1, 0, 0, 90)
    assert_equal Time.local(2006, 1, 1, 0, 5, 0), Time.construct(2006, 1, 1, 0, 0, 300)
  end
  
  def test_minute_overflow
    assert_equal Time.local(2006, 1, 1, 1, 30), Time.construct(2006, 1, 1, 0, 90)
    assert_equal Time.local(2006, 1, 1, 5), Time.construct(2006, 1, 1, 0, 300)
  end
  
  def test_hour_overflow
    assert_equal Time.local(2006, 1, 2, 12), Time.construct(2006, 1, 1, 36)
    assert_equal Time.local(2006, 1, 7), Time.construct(2006, 1, 1, 144)
  end
  
  def test_day_overflow
    assert_equal Time.local(2006, 2, 1), Time.construct(2006, 1, 32)
    assert_equal Time.local(2006, 3, 5), Time.construct(2006, 2, 33)
    assert_equal Time.local(2004, 3, 4), Time.construct(2004, 2, 33)
    assert_equal Time.local(2000, 3, 5), Time.construct(2000, 2, 33)
    
    assert_nothing_raised do
      Time.construct(2006, 1, 56)
    end
    
    assert_raise(RuntimeError) do
      Time.construct(2006, 1, 57)
    end
  end
  
  def test_month_overflow
    assert_equal Time.local(2006, 1), Time.construct(2005, 13)
    assert_equal Time.local(2005, 12), Time.construct(2000, 72)
  end
end