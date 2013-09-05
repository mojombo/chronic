require 'helper'

class TestParsing < TestCase
  # Wed Aug 16 14:00:00 UTC 2006
  TIME_2006_08_16_14_00_00 = Time.local(2006, 8, 16, 14, 0, 0, 0)

  def setup
    @time_2006_08_16_14_00_00 = TIME_2006_08_16_14_00_00
  end

  def test_handle_generic
    time = Chronic.parse("2012-08-02T13:00:00")
    assert_equal Time.local(2012, 8, 2, 13), time

    time = Chronic.parse("2012-08-02T13:00:00+01:00")
    assert_equal Time.utc(2012, 8, 2, 12), time

    time = Chronic.parse("2012-08-02T08:00:00-04:00")
    assert_equal Time.utc(2012, 8, 2, 12), time

    time = Chronic.parse("2013-08-01T19:30:00.345-07:00")
    time2 = Time.parse("2013-08-01 019:30:00.345-07:00")
    assert_in_delta time, time2, 0.001

    time = Chronic.parse("2012-08-02T12:00:00Z")
    assert_equal Time.utc(2012, 8, 2, 12), time

    time = Chronic.parse("2012-01-03 01:00:00.100")
    time2 = Time.parse("2012-01-03 01:00:00.100")
    assert_in_delta time, time2, 0.001

    time = Chronic.parse("2012-01-03 01:00:00.234567")
    time2 = Time.parse("2012-01-03 01:00:00.234567")
    assert_in_delta time, time2, 0.000001

    assert_nil Chronic.parse("1/1/32.1")

    time = Chronic.parse("28th", {:guess => :begin})
    assert_equal Time.new(Time.now.year, Time.now.month, 28), time
  end

  def test_handle_rmn_sd
    time = parse_now("aug 3")
    assert_equal Time.local(2006, 8, 3, 12), time

    time = parse_now("aug 3", :context => :past)
    assert_equal Time.local(2006, 8, 3, 12), time

    time = parse_now("aug. 3")
    assert_equal Time.local(2006, 8, 3, 12), time

    time = parse_now("aug 20")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("aug-20")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("aug 20", :context => :future)
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("may 27")
    assert_equal Time.local(2007, 5, 27, 12), time

    time = parse_now("may 28", :context => :past)
    assert_equal Time.local(2006, 5, 28, 12), time

    time = parse_now("may 28 5pm", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time

    time = parse_now("may 28 at 5pm", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time

    time = parse_now("may 28 at 5:32.19pm", :context => :past)
    assert_equal Time.local(2006, 5, 28, 17, 32, 19), time

    time = parse_now("may 28 at 5:32:19.764")
    assert_in_delta Time.local(2007, 5, 28, 17, 32, 19, 764000), time, 0.001
  end

  def test_handle_rmn_sd_on
    time = parse_now("5pm on may 28")
    assert_equal Time.local(2007, 5, 28, 17), time

    time = parse_now("5pm may 28")
    assert_equal Time.local(2007, 5, 28, 17), time

    time = parse_now("5 on may 28", :ambiguous_time_range => :none)
    assert_equal Time.local(2007, 5, 28, 05), time
  end

  def test_handle_rmn_od
    time = parse_now("may 27th")
    assert_equal Time.local(2007, 5, 27, 12), time

    time = parse_now("may 27th", :context => :past)
    assert_equal Time.local(2006, 5, 27, 12), time

    time = parse_now("may 27th 5:00 pm", :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time

    time = parse_now("may 27th at 5pm", :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time

    time = parse_now("may 27th at 5", :ambiguous_time_range => :none)
    assert_equal Time.local(2007, 5, 27, 5), time
  end

  def test_handle_od_rm
    time = parse_now("fifteenth of this month")
    assert_equal Time.local(2006, 8, 15, 12), time
  end

  def test_handle_od_rmn
    time = parse_now("22nd February")
    assert_equal Time.local(2007, 2, 22, 12), time

    time = parse_now("31st of may at 6:30pm")
    assert_equal Time.local(2007, 5, 31, 18, 30), time

    time = parse_now("11th december 8am")
    assert_equal Time.local(2006, 12, 11, 8), time
  end

  def test_handle_sy_rmn_od
    time = parse_now("2009 May 22nd")
    assert_equal Time.local(2009, 05, 22, 12), time
  end

  def test_handle_sd_rmn
    time = parse_now("22 February")
    assert_equal Time.local(2007, 2, 22, 12), time

    time = parse_now("22 feb")
    assert_equal Time.local(2007, 2, 22, 12), time

    time = parse_now("22-feb")
    assert_equal Time.local(2007, 2, 22, 12), time

    time = parse_now("31 of may at 6:30pm")
    assert_equal Time.local(2007, 5, 31, 18, 30), time

    time = parse_now("11 december 8am")
    assert_equal Time.local(2006, 12, 11, 8), time
  end

  def test_handle_rmn_od_on
    time = parse_now("5:00 pm may 27th", :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time

    time = parse_now("05:00 pm may 27th", :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time

    time = parse_now("5pm on may 27th", :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time

    time = parse_now("5 on may 27th", :ambiguous_time_range => :none)
    assert_equal Time.local(2007, 5, 27, 5), time
  end

  def test_handle_rmn_sy
    time = parse_now("may 97")
    assert_equal Time.local(1997, 5, 16, 12), time

    time = parse_now("may 33", :ambiguous_year_future_bias => 10)
    assert_equal Time.local(2033, 5, 16, 12), time

    time = parse_now("may 32")
    assert_equal Time.local(2032, 5, 16, 12, 0, 0), time
  end

  def test_handle_rdn_rmn_sd_t_tz_sy
    time = parse_now("Mon Apr 02 17:00:00 PDT 2007")
    assert_equal 1175558400, time.to_i
  end

  def test_handle_sy_sm_sd_t_tz
    time = parse_now("2011-07-03 22:11:35 +0100")
    assert_equal 1309727495, time.to_i

    time = parse_now("2011-07-03 22:11:35 +01:00")
    assert_equal 1309727495, time.to_i

    time = parse_now("2011-07-03 16:11:35 -05:00")
    assert_equal 1309727495, time.to_i

    time = parse_now("2011-07-03 21:11:35 UTC")
    assert_equal 1309727495, time.to_i

    time = parse_now("2011-07-03 21:11:35.362 UTC")
    assert_in_delta 1309727495.362, time.to_f, 0.001
  end

  def test_handle_rmn_sd_sy
    time = parse_now("November 18, 2010")
    assert_equal Time.local(2010, 11, 18, 12), time

    time = parse_now("Jan 1,2010")
    assert_equal Time.local(2010, 1, 1, 12), time

    time = parse_now("February 14, 2004")
    assert_equal Time.local(2004, 2, 14, 12), time

    time = parse_now("jan 3 2010")
    assert_equal Time.local(2010, 1, 3, 12), time

    time = parse_now("jan 3 2010 midnight")
    assert_equal Time.local(2010, 1, 4, 0), time

    time = parse_now("jan 3 2010 at midnight")
    assert_equal Time.local(2010, 1, 4, 0), time

    time = parse_now("jan 3 2010 at 4", :ambiguous_time_range => :none)
    assert_equal Time.local(2010, 1, 3, 4), time

    time = parse_now("may 27, 1979")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("may 27 79")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("may 27 79 4:30")
    assert_equal Time.local(1979, 5, 27, 16, 30), time

    time = parse_now("may 27 79 at 4:30", :ambiguous_time_range => :none)
    assert_equal Time.local(1979, 5, 27, 4, 30), time

    time = parse_now("may 27 32")
    assert_equal Time.local(2032, 5, 27, 12, 0, 0), time

    time = parse_now("oct 5 2012 1045pm")
    assert_equal Time.local(2012, 10, 5, 22, 45), time
  end

  def test_handle_rmn_od_sy
    time = parse_now("may 1st 01")
    assert_equal Time.local(2001, 5, 1, 12), time

    time = parse_now("November 18th 2010")
    assert_equal Time.local(2010, 11, 18, 12), time

    time = parse_now("November 18th, 2010")
    assert_equal Time.local(2010, 11, 18, 12), time

    time = parse_now("November 18th 2010 midnight")
    assert_equal Time.local(2010, 11, 19, 0), time

    time = parse_now("November 18th 2010 at midnight")
    assert_equal Time.local(2010, 11, 19, 0), time

    time = parse_now("November 18th 2010 at 4")
    assert_equal Time.local(2010, 11, 18, 16), time

    time = parse_now("November 18th 2010 at 4", :ambiguous_time_range => :none)
    assert_equal Time.local(2010, 11, 18, 4), time

    time = parse_now("March 30th, 1979")
    assert_equal Time.local(1979, 3, 30, 12), time

    time = parse_now("March 30th 79")
    assert_equal Time.local(1979, 3, 30, 12), time

    time = parse_now("March 30th 79 4:30")
    assert_equal Time.local(1979, 3, 30, 16, 30), time

    time = parse_now("March 30th 79 at 4:30", :ambiguous_time_range => :none)
    assert_equal Time.local(1979, 3, 30, 4, 30), time
  end

  def test_handle_od_rmn_sy
    time = parse_now("22nd February 2012")
    assert_equal Time.local(2012, 2, 22, 12), time

    time = parse_now("11th december 79")
    assert_equal Time.local(1979, 12, 11, 12), time
  end

  def test_handle_sd_rmn_sy
    time = parse_now("3 jan 2010")
    assert_equal Time.local(2010, 1, 3, 12), time

    time = parse_now("3 jan 2010 4pm")
    assert_equal Time.local(2010, 1, 3, 16), time

    time = parse_now("27 Oct 2006 7:30pm")
    assert_equal Time.local(2006, 10, 27, 19, 30), time
  end

  def test_handle_sm_sd_sy
    time = parse_now("5/27/1979")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("5/27/1979 4am")
    assert_equal Time.local(1979, 5, 27, 4), time

    time = parse_now("7/12/11")
    assert_equal Time.local(2011, 7, 12, 12), time

    time = parse_now("7/12/11", :endian_precedence => :little)
    assert_equal Time.local(2011, 12, 7, 12), time

    time = parse_now("9/19/2011 6:05:57 PM")
    assert_equal Time.local(2011, 9, 19, 18, 05, 57), time

    # month day overflows
    time = parse_now("30/2/2000")
    assert_nil time

    time = parse_now("2013-03-12 17:00", :context => :past)
    assert_equal Time.local(2013, 3, 12, 17, 0, 0), time
  end

  def test_handle_sd_sm_sy
    time = parse_now("27/5/1979")
    assert_equal Time.local(1979, 5, 27, 12), time

    time = parse_now("27/5/1979 @ 0700")
    assert_equal Time.local(1979, 5, 27, 7), time

    time = parse_now("03/18/2012 09:26 pm")
    assert_equal Time.local(2012, 3, 18, 21, 26), time

    time = parse_now("30.07.2013 16:34:22")
    assert_equal Time.local(2013, 7, 30, 16, 34, 22), time

    time = parse_now("09.08.2013")
    assert_equal Time.local(2013, 8, 9, 12), time

    time = parse_now("30-07-2013 21:53:49")
    assert_equal Time.local(2013, 7, 30, 21, 53, 49), time
  end

  def test_handle_sy_sm_sd
    time = parse_now("2000-1-1")
    assert_equal Time.local(2000, 1, 1, 12), time

    time = parse_now("2006-08-20")
    assert_equal Time.local(2006, 8, 20, 12), time

    time = parse_now("2006-08-20 7pm")
    assert_equal Time.local(2006, 8, 20, 19), time

    time = parse_now("2006-08-20 03:00")
    assert_equal Time.local(2006, 8, 20, 3), time

    time = parse_now("2006-08-20 03:30:30")
    assert_equal Time.local(2006, 8, 20, 3, 30, 30), time

    time = parse_now("2006-08-20 15:30:30")
    assert_equal Time.local(2006, 8, 20, 15, 30, 30), time

    time = parse_now("2006-08-20 15:30.30")
    assert_equal Time.local(2006, 8, 20, 15, 30, 30), time

    time = parse_now("2006-08-20 15:30:30:000536")
    assert_in_delta Time.local(2006, 8, 20, 15, 30, 30, 536), time, 0.000001

    time = parse_now("1902-08-20")
    assert_equal Time.local(1902, 8, 20, 12, 0, 0), time

    time = parse_now("2013.07.30 11:45:23")
    assert_equal Time.local(2013, 7, 30, 11, 45, 23), time

    time = parse_now("2013.08.09")
    assert_equal Time.local(2013, 8, 9, 12, 0, 0), time

    # exif date time original
    time = parse_now("2012:05:25 22:06:50")
    assert_equal Time.local(2012, 5, 25, 22, 6, 50), time
  end

  def test_handle_sm_sd
    time = parse_now("05/06")
    assert_equal Time.local(2007, 5, 6, 12), time

    time = parse_now("05/06", :endian_precedence => [:little, :medium])
    assert_equal Time.local(2007, 6, 5, 12), time

    time = parse_now("05/06 6:05:57 PM")
    assert_equal Time.local(2007, 5, 6, 18, 05, 57), time

    time = parse_now("05/06 6:05:57 PM", :endian_precedence => [:little, :medium])
    assert_equal Time.local(2007, 6, 5, 18, 05, 57), time

    time = parse_now("13/09")
    assert_equal Time.local(2006, 9, 13, 12), time

    # future
    time = parse_now("05/06") # future is default context
    assert_equal Time.local(2007, 5, 6, 12), time

    time = parse_now("1/13", :context => :future)
    assert_equal Time.local(2007, 1, 13, 12), time

    time = parse_now("3/13", :context => :none)
    assert_equal Time.local(2006, 3, 13, 12), time
  end

  # def test_handle_sm_sy
  #   time = parse_now("05/06")
  #   assert_equal Time.local(2006, 5, 16, 12), time
  #
  #   time = parse_now("12/06")
  #   assert_equal Time.local(2006, 12, 16, 12), time
  #
  #   time = parse_now("13/06")
  #   assert_equal nil, time
  # end

  def test_handle_sy_sm
    time = parse_now("2012-06")
    assert_equal Time.local(2012, 06, 16), time

    time = parse_now("2013/12")
    assert_equal Time.local(2013, 12, 16, 12, 0), time
  end

  def test_handle_r
    time = parse_now("9am on Saturday")
    assert_equal Time.local(2006, 8, 19, 9), time

    time = parse_now("on Tuesday")
    assert_equal Time.local(2006, 8, 22, 12), time

    time = parse_now("1:00:00 PM")
    assert_equal Time.local(2006, 8, 16, 13), time

    time = parse_now("01:00:00 PM")
    assert_equal Time.local(2006, 8, 16, 13), time

    time = parse_now("today at 02:00:00", :hours24 => false)
    assert_equal Time.local(2006, 8, 16, 14), time

    time = parse_now("today at 02:00:00 AM", :hours24 => false)
    assert_equal Time.local(2006, 8, 16, 2), time

    time = parse_now("today at 3:00:00", :hours24 => true)
    assert_equal Time.local(2006, 8, 16, 3), time

    time = parse_now("today at 03:00:00", :hours24 => true)
    assert_equal Time.local(2006, 8, 16, 3), time

    time = parse_now("tomorrow at 4a.m.")
    assert_equal Time.local(2006, 8, 17, 4), time
  end

  def test_handle_r_g_r
  end

  def test_handle_srp
  end

  def test_handle_s_r_p
  end

  def test_handle_p_s_r
  end

  def test_handle_s_r_p_a
    time1 = parse_now("two days ago 0:0:0am")
    time2 = parse_now("two days ago 00:00:00am")
    assert_equal time1, time2
  end

  def test_handle_orr
    time = parse_now("5th tuesday in january")
    assert_equal Time.local(2007, 01, 30, 12), time

    time = parse_now("5th tuesday in february")
    assert_equal nil, time

    %W(jan feb march april may june july aug sep oct nov dec).each_with_index do |month, index|
      time = parse_now("5th tuesday in #{month}")

      if time then
        assert_equal time.month, index+1
      end
    end
  end

  def test_handle_o_r_s_r
    time = parse_now("3rd wednesday in november")
    assert_equal Time.local(2006, 11, 15, 12), time

    time = parse_now("10th wednesday in november")
    assert_equal nil, time

    # time = parse_now("3rd wednesday in 2007")
    # assert_equal Time.local(2007, 1, 20, 12), time
  end

  def test_handle_o_r_g_r
    time = parse_now("3rd month next year", :guess => false)
    assert_equal Time.local(2007, 3), time.begin

    time = parse_now("3rd month next year", :guess => false)
    assert_equal Time.local(2007, 3, 1), time.begin

    time = parse_now("3rd thursday this september")
    assert_equal Time.local(2006, 9, 21, 12), time

    now = Time.parse("1/10/2010")
    time = parse_now("3rd thursday this november", :now => now)
    assert_equal Time.local(2010, 11, 18, 12), time

    time = parse_now("4th day last week")
    assert_equal Time.local(2006, 8, 9, 12), time
  end

  def test_handle_sm_rmn_sy
    time = parse_now('30-Mar-11')
    assert_equal Time.local(2011, 3, 30, 12), time

    time = parse_now('31-Aug-12')
    assert_equal Time.local(2012, 8, 31), time
  end

  # end of testing handlers

  def test_parse_guess_r
    time = parse_now("friday")
    assert_equal Time.local(2006, 8, 18, 12), time

    time = parse_now("tue")
    assert_equal Time.local(2006, 8, 22, 12), time

    time = parse_now("5")
    assert_equal Time.local(2006, 8, 16, 17), time

    time = Chronic.parse("5", :now => Time.local(2006, 8, 16, 3, 0, 0, 0), :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 16, 5), time

    time = parse_now("13:00")
    assert_equal Time.local(2006, 8, 17, 13), time

    time = parse_now("13:45")
    assert_equal Time.local(2006, 8, 17, 13, 45), time

    time = parse_now("1:01pm")
    assert_equal Time.local(2006, 8, 16, 13, 01), time

    time = parse_now("2:01pm")
    assert_equal Time.local(2006, 8, 16, 14, 01), time

    time = parse_now("november")
    assert_equal Time.local(2006, 11, 16), time
  end

  def test_parse_guess_rr
    time = parse_now("friday 13:00")
    assert_equal Time.local(2006, 8, 18, 13), time

    time = parse_now("monday 4:00")
    assert_equal Time.local(2006, 8, 21, 16), time

    time = parse_now("sat 4:00", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 19, 4), time

    time = parse_now("sunday 4:20", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 20, 4, 20), time

    time = parse_now("4 pm")
    assert_equal Time.local(2006, 8, 16, 16), time

    time = parse_now("4 am", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 16, 4), time

    time = parse_now("12 pm")
    assert_equal Time.local(2006, 8, 16, 12), time

    time = parse_now("12:01 pm")
    assert_equal Time.local(2006, 8, 16, 12, 1), time

    time = parse_now("12:01 am")
    assert_equal Time.local(2006, 8, 16, 0, 1), time

    time = parse_now("12 am")
    assert_equal Time.local(2006, 8, 16), time

    time = parse_now("4:00 in the morning")
    assert_equal Time.local(2006, 8, 16, 4), time

    time = parse_now("0:10")
    assert_equal Time.local(2006, 8, 17, 0, 10), time

    time = parse_now("november 4")
    assert_equal Time.local(2006, 11, 4, 12), time

    time = parse_now("aug 24")
    assert_equal Time.local(2006, 8, 24, 12), time
  end

  def test_parse_guess_rrr
    time = parse_now("friday 1 pm")
    assert_equal Time.local(2006, 8, 18, 13), time

    time = parse_now("friday 11 at night")
    assert_equal Time.local(2006, 8, 18, 23), time

    time = parse_now("friday 11 in the evening")
    assert_equal Time.local(2006, 8, 18, 23), time

    time = parse_now("sunday 6am")
    assert_equal Time.local(2006, 8, 20, 6), time

    time = parse_now("friday evening at 7")
    assert_equal Time.local(2006, 8, 18, 19), time
  end

  def test_parse_guess_gr
    # year

    time = parse_now("this year", :guess => false)
    assert_equal Time.local(2006, 8, 17), time.begin

    time = parse_now("this year", :context => :past, :guess => false)
    assert_equal Time.local(2006, 1, 1), time.begin

    # month

    time = parse_now("this month")
    assert_equal Time.local(2006, 8, 24, 12), time

    time = parse_now("this month", :context => :past)
    assert_equal Time.local(2006, 8, 8, 12), time

    time = Chronic.parse("next month", :now => Time.local(2006, 11, 15))
    assert_equal Time.local(2006, 12, 16, 12), time

    # month name

    time = parse_now("last november")
    assert_equal Time.local(2005, 11, 16), time

    # fortnight

    time = parse_now("this fortnight")
    assert_equal Time.local(2006, 8, 21, 19, 30), time

    time = parse_now("this fortnight", :context => :past)
    assert_equal Time.local(2006, 8, 14, 19), time

    # week

    time = parse_now("this week")
    assert_equal Time.local(2006, 8, 18, 7, 30), time

    time = parse_now("this week", :context => :past)
    assert_equal Time.local(2006, 8, 14, 19), time

    # weekend

    time = parse_now("this weekend")
    assert_equal Time.local(2006, 8, 20), time

    time = parse_now("this weekend", :context => :past)
    assert_equal Time.local(2006, 8, 13), time

    time = parse_now("last weekend")
    assert_equal Time.local(2006, 8, 13), time

    # day

    time = parse_now("this day")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("this day", :context => :past)
    assert_equal Time.local(2006, 8, 16, 7), time

    time = parse_now("today")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("yesterday")
    assert_equal Time.local(2006, 8, 15, 12), time

    now = Time.parse("2011-05-27 23:10") # after 11pm
    time = parse_now("yesterday", :now => now)
    assert_equal Time.local(2011, 05, 26, 12), time

    time = parse_now("tomorrow")
    assert_equal Time.local(2006, 8, 17, 12), time

    # day name

    time = parse_now("this tuesday")
    assert_equal Time.local(2006, 8, 22, 12), time

    time = parse_now("next tuesday")
    assert_equal Time.local(2006, 8, 22, 12), time

    time = parse_now("last tuesday")
    assert_equal Time.local(2006, 8, 15, 12), time

    time = parse_now("this wed")
    assert_equal Time.local(2006, 8, 23, 12), time

    time = parse_now("next wed")
    assert_equal Time.local(2006, 8, 23, 12), time

    time = parse_now("last wed")
    assert_equal Time.local(2006, 8, 9, 12), time

    monday = Time.local(2006, 8, 21, 12)
    assert_equal monday, parse_now("mon")
    assert_equal monday, parse_now("mun")

    tuesday = Time.local(2006, 8, 22, 12)
    assert_equal tuesday, parse_now("tue")
    assert_equal tuesday, parse_now("tus")

    wednesday = Time.local(2006, 8, 23, 12)
    assert_equal wednesday, parse_now("wed")
    assert_equal wednesday, parse_now("wenns")

    thursday = Time.local(2006, 8, 17, 12)
    assert_equal thursday, parse_now("thu")
    assert_equal thursday, parse_now("thur")

    friday = Time.local(2006, 8, 18, 12)
    assert_equal friday, parse_now("fri")
    assert_equal friday, parse_now("fry")

    saturday = Time.local(2006, 8, 19, 12)
    assert_equal saturday, parse_now("sat")
    assert_equal saturday, parse_now("satterday")

    sunday = Time.local(2006, 8, 20, 12)
    assert_equal sunday, parse_now("sun")
    assert_equal sunday, parse_now("sum")

    # day portion

    time = parse_now("this morning")
    assert_equal Time.local(2006, 8, 16, 9), time

    time = parse_now("tonight")
    assert_equal Time.local(2006, 8, 16, 22), time

    # hour

    time = parse_now("next hr")
    assert_equal Time.local(2006, 8, 16, 15, 30, 0), time

    time = parse_now("next hrs")
    assert_equal Time.local(2006, 8, 16, 15, 30, 0), time

    # minute

    time = parse_now("next min")
    assert_equal Time.local(2006, 8, 16, 14, 1, 30), time

    time = parse_now("next mins")
    assert_equal Time.local(2006, 8, 16, 14, 1, 30), time

    time = parse_now("next minute")
    assert_equal Time.local(2006, 8, 16, 14, 1, 30), time

    # second

    time = parse_now("next sec")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("next secs")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("this second")
    assert_equal Time.local(2006, 8, 16, 14), time

    time = parse_now("this second", :context => :past)
    assert_equal Time.local(2006, 8, 16, 14), time

    time = parse_now("next second")
    assert_equal Time.local(2006, 8, 16, 14, 0, 1), time

    time = parse_now("last second")
    assert_equal Time.local(2006, 8, 16, 13, 59, 59), time
  end

  def test_parse_guess_grr
    time = parse_now("yesterday at 4:00")
    assert_equal Time.local(2006, 8, 15, 16), time

    time = parse_now("today at 9:00")
    assert_equal Time.local(2006, 8, 16, 9), time

    time = parse_now("today at 2100")
    assert_equal Time.local(2006, 8, 16, 21), time

    time = parse_now("this day at 0900")
    assert_equal Time.local(2006, 8, 16, 9), time

    time = parse_now("tomorrow at 0900")
    assert_equal Time.local(2006, 8, 17, 9), time

    time = parse_now("yesterday at 4:00", :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 15, 4), time

    time = parse_now("last friday at 4:00")
    assert_equal Time.local(2006, 8, 11, 16), time

    time = parse_now("next wed 4:00")
    assert_equal Time.local(2006, 8, 23, 16), time

    time = parse_now("yesterday afternoon")
    assert_equal Time.local(2006, 8, 15, 15), time

    time = parse_now("last week tuesday")
    assert_equal Time.local(2006, 8, 8, 12), time

    time = parse_now("tonight at 7")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("tonight 7")
    assert_equal Time.local(2006, 8, 16, 19), time

    time = parse_now("7 tonight")
    assert_equal Time.local(2006, 8, 16, 19), time
  end

  def test_parse_guess_grrr
    time = parse_now("today at 6:00pm")
    assert_equal Time.local(2006, 8, 16, 18), time

    time = parse_now("today at 6:00am")
    assert_equal Time.local(2006, 8, 16, 6), time

    time = parse_now("this day 1800")
    assert_equal Time.local(2006, 8, 16, 18), time

    time = parse_now("yesterday at 4:00pm")
    assert_equal Time.local(2006, 8, 15, 16), time

    time = parse_now("tomorrow evening at 7")
    assert_equal Time.local(2006, 8, 17, 19), time

    time = parse_now("tomorrow morning at 5:30")
    assert_equal Time.local(2006, 8, 17, 5, 30), time

    time = parse_now("next monday at 12:01 am")
    assert_equal Time.local(2006, 8, 21, 00, 1), time

    time = parse_now("next monday at 12:01 pm")
    assert_equal Time.local(2006, 8, 21, 12, 1), time

    # with context
    time = parse_now("sunday at 8:15pm", :context => :past)
    assert_equal Time.local(2006, 8, 13, 20, 15), time
  end

  def test_parse_guess_rgr
    time = parse_now("afternoon yesterday")
    assert_equal Time.local(2006, 8, 15, 15), time

    time = parse_now("tuesday last week")
    assert_equal Time.local(2006, 8, 8, 12), time
  end

  def test_parse_guess_a_ago
    time = parse_now("AN hour ago")
    assert_equal Time.local(2006, 8, 16, 13), time

    time = parse_now("A day ago")
    assert_equal Time.local(2006, 8, 15, 14), time

    time = parse_now("a month ago")
    assert_equal Time.local(2006, 7, 16, 14), time

    time = parse_now("a year ago")
    assert_equal Time.local(2005, 8, 16, 14), time
  end

  def test_parse_guess_s_r_p
    # past

    time = parse_now("3 years ago")
    assert_equal Time.local(2003, 8, 16, 14), time

    time = parse_now("1 month ago")
    assert_equal Time.local(2006, 7, 16, 14), time

    time = parse_now("1 fortnight ago")
    assert_equal Time.local(2006, 8, 2, 14), time

    time = parse_now("2 fortnights ago")
    assert_equal Time.local(2006, 7, 19, 14), time

    time = parse_now("3 weeks ago")
    assert_equal Time.local(2006, 7, 26, 14), time

    time = parse_now("2 weekends ago")
    assert_equal Time.local(2006, 8, 5), time

    time = parse_now("3 days ago")
    assert_equal Time.local(2006, 8, 13, 14), time

    #time = parse_now("1 monday ago")
    #assert_equal Time.local(2006, 8, 14, 12), time

    time = parse_now("5 mornings ago")
    assert_equal Time.local(2006, 8, 12, 9), time

    time = parse_now("7 hours ago")
    assert_equal Time.local(2006, 8, 16, 7), time

    time = parse_now("3 minutes ago")
    assert_equal Time.local(2006, 8, 16, 13, 57), time

    time = parse_now("20 seconds before now")
    assert_equal Time.local(2006, 8, 16, 13, 59, 40), time

    # future

    time = parse_now("3 years from now")
    assert_equal Time.local(2009, 8, 16, 14, 0, 0), time

    time = parse_now("6 months hence")
    assert_equal Time.local(2007, 2, 16, 14), time

    time = parse_now("3 fortnights hence")
    assert_equal Time.local(2006, 9, 27, 14), time

    time = parse_now("1 week from now")
    assert_equal Time.local(2006, 8, 23, 14, 0, 0), time

    time = parse_now("1 weekend from now")
    assert_equal Time.local(2006, 8, 19), time

    time = parse_now("2 weekends from now")
    assert_equal Time.local(2006, 8, 26), time

    time = parse_now("1 day hence")
    assert_equal Time.local(2006, 8, 17, 14), time

    time = parse_now("5 mornings hence")
    assert_equal Time.local(2006, 8, 21, 9), time

    time = parse_now("1 hour from now")
    assert_equal Time.local(2006, 8, 16, 15), time

    time = parse_now("20 minutes hence")
    assert_equal Time.local(2006, 8, 16, 14, 20), time

    time = parse_now("20 seconds from now")
    assert_equal Time.local(2006, 8, 16, 14, 0, 20), time

    time = Chronic.parse("2 months ago", :now => Time.parse("2007-03-07 23:30"))
    assert_equal Time.local(2007, 1, 7, 23, 30), time

    # Two repeaters
    time = parse_now("25 minutes and 20 seconds from now")
    assert_equal Time.local(2006, 8, 16, 14, 25, 20), time

    time = parse_now("24 hours and 20 minutes from now")
    assert_equal Time.local(2006, 8, 17, 14, 20, 0), time

    time = parse_now("24 hours 20 minutes from now")
    assert_equal Time.local(2006, 8, 17, 14, 20, 0), time
  end

  def test_parse_guess_p_s_r
    time = parse_now("in 3 hours")
    assert_equal Time.local(2006, 8, 16, 17), time
  end

  def test_parse_guess_s_r_p_a
    # past

    time = parse_now("3 years ago tomorrow")
    assert_equal Time.local(2003, 8, 17, 12), time

    time = parse_now("3 years ago this friday")
    assert_equal Time.local(2003, 8, 18, 12), time

    time = parse_now("3 months ago saturday at 5:00 pm")
    assert_equal Time.local(2006, 5, 19, 17), time

    time = parse_now("2 days from this second")
    assert_equal Time.local(2006, 8, 18, 14), time

    time = parse_now("7 hours before tomorrow at midnight")
    assert_equal Time.local(2006, 8, 17, 17), time

    # future
  end

  def test_parse_guess_o_r_g_r
    time = parse_now("3rd month next year", :guess => false)
    assert_equal Time.local(2007, 3), time.begin

    time = parse_now("3rd month next year", :guess => false)
    assert_equal Time.local(2007, 3, 1), time.begin

    time = parse_now("3rd thursday this september")
    assert_equal Time.local(2006, 9, 21, 12), time

    now = Time.parse("1/10/2010")
    time = parse_now("3rd thursday this november", :now => now)
    assert_equal Time.local(2010, 11, 18, 12), time

    time = parse_now("4th day last week")
    assert_equal Time.local(2006, 8, 9, 12), time
  end

  def test_parse_guess_nonsense
    time = parse_now("some stupid nonsense")
    assert_equal nil, time

    time = parse_now("Ham Sandwich")
    assert_equal nil, time
  end

  def test_parse_span
    span = parse_now("friday", :guess => false)
    assert_equal Time.local(2006, 8, 18), span.begin
    assert_equal Time.local(2006, 8, 19), span.end

    span = parse_now("november", :guess => false)
    assert_equal Time.local(2006, 11), span.begin
    assert_equal Time.local(2006, 12), span.end

    span = Chronic.parse("weekend" , :now => @time_2006_08_16_14_00_00, :guess => false)
    assert_equal Time.local(2006, 8, 19), span.begin
    assert_equal Time.local(2006, 8, 21), span.end
  end

  def test_parse_with_endian_precedence
    date = '11/02/2007'

    expect_for_middle_endian = Time.local(2007, 11, 2, 12)
    expect_for_little_endian = Time.local(2007, 2, 11, 12)

    # default precedence should be toward middle endianness
    assert_equal expect_for_middle_endian, Chronic.parse(date)

    assert_equal expect_for_middle_endian, Chronic.parse(date, :endian_precedence => [:middle, :little])

    assert_equal expect_for_little_endian, Chronic.parse(date, :endian_precedence => [:little, :middle])
  end

  def test_parse_words
    assert_equal parse_now("33 days from now"), parse_now("thirty-three days from now")
    assert_equal parse_now("2867532 seconds from now"), parse_now("two million eight hundred and sixty seven thousand five hundred and thirty two seconds from now")
    assert_equal parse_now("may 10th"), parse_now("may tenth")
    assert_equal parse_now("second monday in january"), parse_now("2nd monday in january")
  end

  def test_relative_to_an_hour_before
    # example prenormalization "10 to 2" becomes "10 minutes past 2"
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 to 2")
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 till 2")
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 prior to 2")
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 before 2")

    # uses the current hour, so 2006-08-16 13:50:00, not 14:50
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 to")
    assert_equal Time.local(2006, 8, 16, 13, 50), parse_now("10 till")

    assert_equal Time.local(2006, 8, 16, 15, 45), parse_now("quarter to 4")
  end

  def test_relative_to_an_hour_after
    # not nil
    assert_equal Time.local(2006, 8, 16, 14, 10), parse_now("10 after 2")
    assert_equal Time.local(2006, 8, 16, 14, 10), parse_now("10 past 2")
    assert_equal Time.local(2006, 8, 16, 14, 30), parse_now("half past 2")
  end

  def test_parse_only_complete_pointers
    assert_equal parse_now("eat pasty buns today at 2pm"), @time_2006_08_16_14_00_00
    assert_equal parse_now("futuristically speaking today at 2pm"), @time_2006_08_16_14_00_00
    assert_equal parse_now("meeting today at 2pm"), @time_2006_08_16_14_00_00
  end

  def test_am_pm
    assert_equal Time.local(2006, 8, 16), parse_now("8/16/2006 at 12am")
    assert_equal Time.local(2006, 8, 16, 12), parse_now("8/16/2006 at 12pm")
  end

  def test_a_p
    assert_equal Time.local(2006, 8, 16, 0, 15), parse_now("8/16/2006 at 12:15a")
    assert_equal Time.local(2006, 8, 16, 18, 30), parse_now("8/16/2006 at 6:30p")
  end

  def test_seasons
    t = parse_now("this spring", :guess => false)
    assert_equal Time.local(2007, 3, 20), t.begin
    assert_equal Time.local(2007, 6, 20), t.end

    t = parse_now("this winter", :guess => false)
    assert_equal Time.local(2006, 12, 22), t.begin
    assert_equal Time.local(2007, 3, 19), t.end

    t = parse_now("last spring", :guess => false)
    assert_equal Time.local(2006, 3, 20), t.begin
    assert_equal Time.local(2006, 6, 20), t.end

    t = parse_now("last winter", :guess => false)
    assert_equal Time.local(2005, 12, 22), t.begin
    assert_equal Time.local(2006, 3, 19), t.end

    t = parse_now("next spring", :guess => false)
    assert_equal Time.local(2007, 3, 20), t.begin
    assert_equal Time.local(2007, 6, 20), t.end
  end

  # regression

  # def test_partial
  #   assert_equal '', parse_now("2 hours")
  # end

  def test_days_in_november
    t1 = Chronic.parse('1st thursday in november', :now => Time.local(2007))
    assert_equal Time.local(2007, 11, 1, 12), t1

    t1 = Chronic.parse('1st friday in november', :now => Time.local(2007))
    assert_equal Time.local(2007, 11, 2, 12), t1

    t1 = Chronic.parse('1st saturday in november', :now => Time.local(2007))
    assert_equal Time.local(2007, 11, 3, 12), t1

    # t1 = Chronic.parse('1st sunday in november', :now => Time.local(2007))
    # assert_equal Time.local(2007, 11, 4, 12), t1

    # Chronic.debug = true
    #
    # t1 = Chronic.parse('1st monday in november', :now => Time.local(2007))
    # assert_equal Time.local(2007, 11, 5, 11), t1
  end

  def test_now_changes
    t1 = Chronic.parse("now")
    sleep 0.1
    t2 = Chronic.parse("now")
    refute_equal t1, t2
  end

  def test_noon
    t1 = Chronic.parse('2011-01-01 at noon', :ambiguous_time_range => :none)
    assert_equal Time.local(2011, 1, 1, 12, 0), t1
  end

  def test_handle_rdn_rmn_sd
    time = parse_now("Thu Aug 10")
    assert_equal Time.local(2006, 8, 10, 12), time

    time = parse_now("Thursday July 31")
    assert_equal Time.local(2006, 7, 31, 12), time

    time = parse_now("Thursday December 31")
    assert_equal Time.local(2006, 12, 31, 12), time
  end

  def test_handle_rdn_rmn_sd_rt
    time = parse_now("Thu Aug 10 4pm")
    assert_equal Time.local(2006, 8, 10, 16), time

    time = parse_now("Thu Aug 10 at 4pm")
    assert_equal Time.local(2006, 8, 10, 16), time
  end

  def test_handle_rdn_rmn_od_rt
    time = parse_now("Thu Aug 10th at 4pm")
    assert_equal Time.local(2006, 8, 10, 16), time
  end

  def test_handle_rdn_od_rt
    time = parse_now("Thu 17th at 4pm")
    assert_equal Time.local(2006, 8, 17, 16), time

    time = parse_now("Thu 16th at 4pm")
    assert_equal Time.local(2006, 8, 16, 16), time

    time = parse_now("Thu 1st at 4pm")
    assert_equal Time.local(2006, 9, 1, 16), time

    time = parse_now("Thu 1st at 4pm", :context => :past)
    assert_equal Time.local(2006, 8, 1, 16), time
  end

  def test_handle_rdn_od
    time = parse_now("Thu 17th")
    assert_equal Time.local(2006, 8, 17, 12), time
  end

  def test_handle_rdn_rmn_sd_sy
    time = parse_now("Thu Aug 10 2006")
    assert_equal Time.local(2006, 8, 10, 12), time

    time = parse_now("Thursday July 31 2006")
    assert_equal Time.local(2006, 7, 31, 12), time

    time = parse_now("Thursday December 31 2006")
    assert_equal Time.local(2006, 12, 31, 12), time

    time = parse_now("Thursday December 30 2006")
    assert_equal Time.local(2006, 12, 30, 12), time
  end

  def test_handle_rdn_rmn_od
    time = parse_now("Thu Aug 10th")
    assert_equal Time.local(2006, 8, 10, 12), time

    time = parse_now("Thursday July 31st")
    assert_equal Time.local(2006, 7, 31, 12), time

    time = parse_now("Thursday December 31st")
    assert_equal Time.local(2006, 12, 31, 12), time
  end

  def test_handle_rdn_rmn_od_sy
    time = parse_now("Thu Aug 10th 2005")
    assert_equal Time.local(2005, 8, 10, 12), time

    time = parse_now("Thursday July 31st 2005")
    assert_equal Time.local(2005, 7, 31, 12), time

    time = parse_now("Thursday December 31st 2005")
    assert_equal Time.local(2005, 12, 31, 12), time

    time = parse_now("Thursday December 30th 2005")
    assert_equal Time.local(2005, 12, 30, 12), time
  end

  def test_normalizing_day_portions
    assert_equal pre_normalize("8:00 pm February 11"), pre_normalize("8:00 p.m. February 11")
  end

  private
  def parse_now(string, options={})
    Chronic.parse(string, {:now => TIME_2006_08_16_14_00_00 }.merge(options))
  end
  def pre_normalize(s)
    Chronic::Parser.new.pre_normalize s
  end
end
