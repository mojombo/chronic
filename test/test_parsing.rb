require 'chronic'
require 'test/unit'

class TestParsing < Test::Unit::TestCase
  
  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @time_2006_08_16_14_00_00 = Time.local(2006, 8, 16, 14, 0, 0, 0)
    @time_2006_08_16_03_00_00 = Time.local(2006, 8, 16, 3, 0, 0, 0)
  end
  
  def test__parse_guess_dates
    # rm_sd

    time = Chronic.parse("may 27", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2007, 5, 27, 12), time
    
    time = Chronic.parse("may 28", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 5, 28, 12), time
    
    time = Chronic.parse("may 28 5pm", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time
    
    time = Chronic.parse("may 28 at 5pm", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 5, 28, 17), time
    
    # rm_od
    
    time = Chronic.parse("may 27th", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2007, 5, 27, 12), time
    
    time = Chronic.parse("may 27th", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 5, 27, 12), time
    
    time = Chronic.parse("may 27th 5:00 pm", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time
    
    time = Chronic.parse("may 27th at 5pm", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 5, 27, 17), time
    
    time = Chronic.parse("may 27th at 5", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2007, 5, 27, 5), time
    
    # rm_sy
    
    time = Chronic.parse("June 1979", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 6, 16, 0), time
    
    time = Chronic.parse("dec 79", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 12, 16, 12), time
    
    # rm_sd_sy
    
    time = Chronic.parse("jan 3 2010", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2010, 1, 3, 12), time
    
    time = Chronic.parse("jan 3 2010 midnight", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2010, 1, 4, 0), time
    
    time = Chronic.parse("jan 3 2010 at midnight", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2010, 1, 4, 0), time
    
    time = Chronic.parse("jan 3 2010 at 4", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2010, 1, 3, 4), time
    
    #time = Chronic.parse("January 12, '00", :now => @time_2006_08_16_14_00_00)
    #assert_equal Time.local(2000, 1, 12, 12), time
    
    time = Chronic.parse("may 27 79", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 5, 27, 12), time
    
    time = Chronic.parse("may 27 79 4:30", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 5, 27, 16, 30), time
    
    time = Chronic.parse("may 27 79 at 4:30", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(1979, 5, 27, 4, 30), time
    
    # sd_rm_sy

    time = Chronic.parse("3 jan 2010", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2010, 1, 3, 12), time
    
    time = Chronic.parse("3 jan 2010 4pm", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2010, 1, 3, 16), time
    
    # sm_sd_sy
    
    time = Chronic.parse("5/27/1979", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 5, 27, 12), time
    
    time = Chronic.parse("5/27/1979 4am", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 5, 27, 4), time
    
    # sd_sm_sy
    
    time = Chronic.parse("27/5/1979", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 5, 27, 12), time
    
    time = Chronic.parse("27/5/1979 @ 0700", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(1979, 5, 27, 7), time
    
    # sm_sy
    
    time = Chronic.parse("05/06", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 5, 16, 12), time
    
    time = Chronic.parse("12/06", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 12, 16, 12), time
    
    time = Chronic.parse("13/06", :now => @time_2006_08_16_14_00_00)
    assert_equal nil, time
    
    # sy_sm_sd
    
    time = Chronic.parse("2000-1-1", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2000, 1, 1, 12), time
    
    time = Chronic.parse("2006-08-20", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 20, 12), time
    
    time = Chronic.parse("2006-08-20 7pm", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 20, 19), time
    
    time = Chronic.parse("2006-08-20 03:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 20, 3), time
    
    # rm_sd_rt
    
    #time = Chronic.parse("jan 5 13:00", :now => @time_2006_08_16_14_00_00)
    #assert_equal Time.local(2007, 1, 5, 13), time
    
    # due to limitations of the Time class, these don't work
    
    time = Chronic.parse("may 40", :now => @time_2006_08_16_14_00_00)
    assert_equal nil, time
    
    time = Chronic.parse("may 27 40", :now => @time_2006_08_16_14_00_00)
    assert_equal nil, time
    
    time = Chronic.parse("1800-08-20", :now => @time_2006_08_16_14_00_00)
    assert_equal nil, time
  end

  def test_parse_guess_r
    time = Chronic.parse("friday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 12), time
    
    time = Chronic.parse("5", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 17), time
    
    time = Chronic.parse("5", :now => @time_2006_08_16_03_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 16, 5), time
    
    time = Chronic.parse("13:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 17, 13), time
    
    time = Chronic.parse("13:45", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 17, 13, 45), time
    
    time = Chronic.parse("november", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 11, 16), time
  end
  
  def test_parse_guess_rr
    time = Chronic.parse("friday 13:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 13), time
    
    time = Chronic.parse("monday 4:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 21, 16), time
    
    time = Chronic.parse("sat 4:00", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 19, 4), time
    
    time = Chronic.parse("sunday 4:20", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 20, 4, 20), time
    
    time = Chronic.parse("4 pm", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 16), time
    
    time = Chronic.parse("4 am", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 16, 4), time
    
    time = Chronic.parse("4:00 in the morning", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 4), time
    
    #time = Chronic.parse("november 4", :now => @time_2006_08_16_14_00_00)
    #assert_equal Time.local(2006, 11, 4, 12), time
  end
  
  def test_parse_guess_rrr
    time = Chronic.parse("friday 1 pm", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 13), time
    
    time = Chronic.parse("friday 11 at night", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 23), time
    
    time = Chronic.parse("friday 11 in the evening", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 23), time
    
    time = Chronic.parse("sunday 6am", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 20, 6), time
  end
  
  def test_parse_guess_gr
    time = Chronic.parse("this week", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 7, 30), time
    
    time = Chronic.parse("this week", :now => @time_2006_08_16_14_00_00, :context => :past)
    assert_equal Time.local(2006, 8, 14, 19), time
    
    time = Chronic.parse("today", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 12), time
    
    time = Chronic.parse("yesterday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 15, 12), time
    
    time = Chronic.parse("tomorrow", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 17, 12), time
    
    time = Chronic.parse("this tuesday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 22, 12), time
    
    time = Chronic.parse("next tuesday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 22, 12), time
    
    time = Chronic.parse("last tuesday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 15, 12), time
    
    time = Chronic.parse("this wed", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 23, 12), time
    
    time = Chronic.parse("next wed", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 23, 12), time
    
    time = Chronic.parse("last wed", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 9, 12), time
    
    time = Chronic.parse("this morning", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 9), time
    
    time = Chronic.parse("tonight", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 22), time
    
    time = Chronic.parse("last november", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2005, 11, 16), time
    
    time = Chronic.parse("this second", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 14), time
    
    
  end
  
  def test_parse_guess_grr
    time = Chronic.parse("yesterday at 4:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 15, 16), time
    
    time = Chronic.parse("yesterday at 4:00", :now => @time_2006_08_16_14_00_00, :ambiguous_time_range => :none)
    assert_equal Time.local(2006, 8, 15, 4), time
    
    time = Chronic.parse("last friday at 4:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 11, 16), time
    
    time = Chronic.parse("next wed 4:00", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 23, 16), time
    
    time = Chronic.parse("yesterday afternoon", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 15, 15), time
    
    time = Chronic.parse("last week tuesday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 8, 12), time
  end
  
  def test_parse_guess_grrr
    time = Chronic.parse("yesterday at 4:00pm", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 15, 16), time
  end
  
  def test_parse_guess_rgr
    time = Chronic.parse("afternoon yesterday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 15, 15), time
    
    time = Chronic.parse("tuesday last week", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 8, 12), time
  end
  
  def test_parse_guess_s_r_p
    # past
    
    time = Chronic.parse("3 years ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2003, 8, 16, 12), time
    
    time = Chronic.parse("1 month ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 7, 16, 12), time
    
    time = Chronic.parse("1 fortnight ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 2, 12), time
    
    time = Chronic.parse("2 fortnights ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 7, 19, 12), time
    
    time = Chronic.parse("3 weeks ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 7, 26, 12), time
    
    time = Chronic.parse("3 days ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 13, 14, 0, 30), time
    
    #time = Chronic.parse("1 monday ago", :now => @time_2006_08_16_14_00_00)
    #assert_equal Time.local(2006, 8, 14, 12), time
    
    time = Chronic.parse("5 mornings ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 12, 9), time
    
    time = Chronic.parse("7 hours ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 7, 0, 30), time
    
    time = Chronic.parse("3 minutes ago", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 13, 57), time
    
    time = Chronic.parse("20 seconds before now", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 13, 59, 40), time

    # future
    
    time = Chronic.parse("3 years from now", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2009, 8, 16, 12), time
    
    time = Chronic.parse("6 months hence", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2007, 2, 16, 12), time
    
    time = Chronic.parse("3 fortnights hence", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 9, 27, 12), time
    
    time = Chronic.parse("1 week from now", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 23, 12), time
    
    time = Chronic.parse("1 day hence", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 17, 14, 0, 30), time
    
    time = Chronic.parse("5 mornings hence", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 21, 9), time
    
    time = Chronic.parse("1 hour from now", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 15, 0, 30), time
    
    time = Chronic.parse("20 minutes hence", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 14, 20), time
    
    time = Chronic.parse("20 seconds from now", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 14, 0, 20), time
  end
  
  def test_parse_guess_p_s_r
    time = Chronic.parse("in 3 hours", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 16, 17, 0, 30), time
  end
  
  def test_parse_guess_s_r_p_a
    # past
    
    time = Chronic.parse("3 years ago tomorrow", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2003, 8, 17, 12), time
    
    time = Chronic.parse("3 years ago this friday", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2003, 8, 18, 12), time
    
    time = Chronic.parse("3 months ago saturday at 5:00 pm", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 5, 19, 17), time
    
    time = Chronic.parse("2 days from this second", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 18, 14), time
    
    time = Chronic.parse("7 hours before tomorrow at midnight", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 17, 17), time
    
    # future
  end
  
  def test_parse_guess_o_r_s_r
    time = Chronic.parse("3rd wednesday in november", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 11, 15, 12), time
    
    time = Chronic.parse("10th wednesday in november", :now => @time_2006_08_16_14_00_00)
    assert_equal nil, time
  end
  
  def test_parse_guess_o_r_g_r
    time = Chronic.parse("3rd month next year", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2007, 3, 16, 12, 30), time
    
    time = Chronic.parse("3rd thursday this september", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 9, 21, 12), time
    
    time = Chronic.parse("4th day last week", :now => @time_2006_08_16_14_00_00)
    assert_equal Time.local(2006, 8, 9, 12), time
  end
  
  def test_parse_guess_nonsense
    time = Chronic.parse("some stupid nonsense", :now => @time_2006_08_16_14_00_00)
    assert_equal nil, time
  end
  
  def test_parse_span
    span = Chronic.parse("friday", :now => @time_2006_08_16_14_00_00, :guess => false)
    assert_equal Time.local(2006, 8, 18), span.begin
    assert_equal Time.local(2006, 8, 19), span.end
    
    span = Chronic.parse("november", :now => @time_2006_08_16_14_00_00, :guess => false)
    assert_equal Time.local(2006, 11), span.begin
    assert_equal Time.local(2006, 12), span.end
  end
  
  def test_argument_validation
    assert_raise(Chronic::InvalidArgumentException) do
      time = Chronic.parse("may 27", :foo => :bar)
    end
    
    assert_raise(Chronic::InvalidArgumentException) do
      time = Chronic.parse("may 27", :context => :bar)
    end
  end
  
end