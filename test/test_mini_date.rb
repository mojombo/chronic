require 'helper'

class TestMiniDate < Test::Unit::TestCase
  def test_valid_month
    assert_raise(ArgumentError){ Chronic::MiniDate.new(0,12) }
    assert_raise(ArgumentError){ Chronic::MiniDate.new(13,1) }
  end
  
  def test_is_between
    m=Chronic::MiniDate.new(3,2)
    assert m.is_between?(Chronic::MiniDate.new(2,4), Chronic::MiniDate.new(4,7))
    assert !m.is_between?(Chronic::MiniDate.new(1,5), Chronic::MiniDate.new(2,7))    
    
    #There was a hang if date tested is in december and outside the testing range
    m=Chronic::MiniDate.new(12,24)
    assert !m.is_between?(Chronic::MiniDate.new(10,1), Chronic::MiniDate.new(12,21))
  end
  
  def test_is_between_short_range
    m=Chronic::MiniDate.new(5,10)
    assert m.is_between?(Chronic::MiniDate.new(5,3), Chronic::MiniDate.new(5,12))
    assert !m.is_between?(Chronic::MiniDate.new(5,11), Chronic::MiniDate.new(5,15))
  end
  
  def test_is_between_wrapping_range
    m=Chronic::MiniDate.new(1,1)
    assert m.is_between?(Chronic::MiniDate.new(11,11), Chronic::MiniDate.new(2,2))
    m=Chronic::MiniDate.new(12,12)
    assert m.is_between?(Chronic::MiniDate.new(11,11), Chronic::MiniDate.new(1,5))
  end
  
end
