require 'helper'

class TestParsingLocalizedRu < TestCase
  # Wed Aug 16 14:00:00 UTC 2006
  TIME_2006_08_16_14_00_00 = Time.local(2006, 8, 16, 14, 0, 0, 0)

  def setup
    @time_2006_08_16_14_00_00 = TIME_2006_08_16_14_00_00
  end

  def test_handle_rmn_sd
    time = parse_now("авг 3")
    assert_equal Time.local(2007, 8, 3, 12), time

    time = parse_now("авг. 3")
    assert_equal Time.local(2007, 8, 3, 12), time

    time = parse_now("авг 20")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("авг 20", :context => :future)
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("мая 27")
    assert_equal Time.local(2007, 5, 27, 12), time

    time = parse_now("мая 28", :context => :past)
    assert_equal Time.local(2006, 5, 28, 12), time

    time = parse_now("мая 28 5 вечера", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time

    time = parse_now("мая 28 в 5 вечера", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time

    time = parse_now("мая 28 в 5:32.19 вечера", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17, 32, 19), time

    time = parse_now("мая 28 в 5:32:19.764")
    assert_in_delta Time.local(2007, 5, 28, 17, 32, 19, 764000), time, 0.001

    time = parse_now("1 апр 2014", now: nil)
    assert_equal Time.local(2014, 4, 1, 12), time

    time = parse_now("1 апр. 2014", now: nil)
    assert_equal Time.local(2014, 4, 1, 12), time

    time = parse_now("1 апреля 2014", now: nil)
    assert_equal Time.local(2014, 4, 1, 12), time
  end

  def test_handle_rmn_sd_on
    time = parse_now("2 дня назад")
    assert_equal Time.local(2006, 8, 14, 14), time

    time = parse_now("6 месяцев назад")
    assert_equal Time.local(2006, 2, 16, 14), time

    time = parse_now("3 года назад")
    assert_equal Time.local(2003, 8, 16, 14), time

    time = parse_now("1 месяц назад")
    assert_equal Time.local(2006, 7, 16, 14), time

    time = parse_now("3 года, 1 месяц назад от сейчас")
    assert_equal Time.local(2003, 7, 16, 14), time

    time = parse_now("3 года, 1 месяц назад")
    assert_equal Time.local(2003, 7, 16, 14), time
  end

  private
  def parse_now(string, options={})
    Chronic.parse(string, {:now => TIME_2006_08_16_14_00_00, :locale => :ru }.merge(options))
  end
  def pre_normalize(s)
    Chronic::Parser.new.pre_normalize s
  end
end
