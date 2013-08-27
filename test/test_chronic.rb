require 'helper'

class TestChronic < TestCase

  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_pre_normalize
    assert_equal Chronic::Parser.new.pre_normalize('12:55 pm'), Chronic::Parser.new.pre_normalize('12.55 pm')
  end

  def test_pre_normalize_numerized_string
    string = 'two and a half years'
    assert_equal Chronic::Numerizer.numerize(string), Chronic::Parser.new.pre_normalize(string)
  end

  def test_post_normalize_am_pm_aliases
    # affect wanted patterns

    tokens = [Chronic::Token.new("5:00"), Chronic::Token.new("morning")]
    tokens[0].tag(Chronic::RepeaterTime.new("5:00"))
    tokens[1].tag(Chronic::RepeaterDayPortion.new(:morning))

    assert_equal :morning, tokens[1].tags[0].type

    tokens = Chronic::Handlers.dealias_and_disambiguate_times(tokens, {})

    assert_equal :am, tokens[1].tags[0].type
    assert_equal 2, tokens.size

    # don't affect unwanted patterns

    tokens = [Chronic::Token.new("friday"), Chronic::Token.new("morning")]
    tokens[0].tag(Chronic::RepeaterDayName.new(:friday))
    tokens[1].tag(Chronic::RepeaterDayPortion.new(:morning))

    assert_equal :morning, tokens[1].tags[0].type

    tokens = Chronic::Handlers.dealias_and_disambiguate_times(tokens, {})

    assert_equal :morning, tokens[1].tags[0].type
    assert_equal 2, tokens.size
  end

  def test_guess
    span = Chronic::Span.new(Time.local(2006, 8, 16, 0), Time.local(2006, 8, 17, 0))
    assert_equal Time.local(2006, 8, 16, 12), Chronic::Parser.new.guess(span)

    span = Chronic::Span.new(Time.local(2006, 8, 16, 0), Time.local(2006, 8, 17, 0, 0, 1))
    assert_equal Time.local(2006, 8, 16, 12), Chronic::Parser.new.guess(span)

    span = Chronic::Span.new(Time.local(2006, 11), Time.local(2006, 12))
    assert_equal Time.local(2006, 11, 16), Chronic::Parser.new.guess(span)
  end

  def test_endian_definitions
    # middle, little
    endians = [
      Chronic::Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_day, [:separator_slash, :separator_dash], :scalar_year, :separator_at?, 'time?'], :handle_sm_sd_sy),
      Chronic::Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_day, :separator_at?, 'time?'], :handle_sm_sd),
      Chronic::Handler.new([:scalar_day, [:separator_slash, :separator_dash], :scalar_month, :separator_at?, 'time?'], :handle_sd_sm),
      Chronic::Handler.new([:scalar_day, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_year, :separator_at?, 'time?'], :handle_sd_sm_sy)
    ]

    assert_equal endians, Chronic::Parser.new.definitions[:endian]

    defs = Chronic::Parser.new.definitions(:endian_precedence => :little)
    assert_equal endians.reverse, defs[:endian]

    defs = Chronic::Parser.new.definitions(:endian_precedence => [:little, :middle])
    assert_equal endians.reverse, defs[:endian]

    assert_raises(ArgumentError) do
      Chronic::Parser.new.definitions(:endian_precedence => :invalid)
    end
  end

  def test_debug
    require 'stringio'
    $stdout = StringIO.new
    Chronic.debug = true

    Chronic.parse 'now'
    assert $stdout.string.include?('this(grabber-this)')
  ensure
    $stdout = STDOUT
    Chronic.debug = false
  end

  # Chronic.construct

  def test_normal
    assert_equal Time.local(2006, 1, 2, 0, 0, 0), Chronic.construct(2006, 1, 2, 0, 0, 0)
    assert_equal Time.local(2006, 1, 2, 3, 0, 0), Chronic.construct(2006, 1, 2, 3, 0, 0)
    assert_equal Time.local(2006, 1, 2, 3, 4, 0), Chronic.construct(2006, 1, 2, 3, 4, 0)
    assert_equal Time.local(2006, 1, 2, 3, 4, 5), Chronic.construct(2006, 1, 2, 3, 4, 5)
  end

  def test_second_overflow
    assert_equal Time.local(2006, 1, 1, 0, 1, 30), Chronic.construct(2006, 1, 1, 0, 0, 90)
    assert_equal Time.local(2006, 1, 1, 0, 5, 0), Chronic.construct(2006, 1, 1, 0, 0, 300)
  end

  def test_minute_overflow
    assert_equal Time.local(2006, 1, 1, 1, 30), Chronic.construct(2006, 1, 1, 0, 90)
    assert_equal Time.local(2006, 1, 1, 5), Chronic.construct(2006, 1, 1, 0, 300)
  end

  def test_hour_overflow
    assert_equal Time.local(2006, 1, 2, 12), Chronic.construct(2006, 1, 1, 36)
    assert_equal Time.local(2006, 1, 7), Chronic.construct(2006, 1, 1, 144)
  end

  def test_day_overflow
    assert_equal Time.local(2006, 2, 1), Chronic.construct(2006, 1, 32)
    assert_equal Time.local(2006, 3, 5), Chronic.construct(2006, 2, 33)
    assert_equal Time.local(2004, 3, 4), Chronic.construct(2004, 2, 33)
    assert_equal Time.local(2000, 3, 4), Chronic.construct(2000, 2, 33)

    assert_raises(RuntimeError) do
      Chronic.construct(2006, 1, 57)
    end
  end

  def test_month_overflow
    assert_equal Time.local(2006, 1), Chronic.construct(2005, 13)
    assert_equal Time.local(2005, 12), Chronic.construct(2000, 72)
  end

  def test_time
    org = Chronic.time_class
    begin
      Chronic.time_class = ::Time
      assert_equal ::Time.new(2013, 8, 27, 20, 30, 40, '+05:30'), Chronic.construct(2013, 8, 27, 20, 30, 40, '+05:30')
      assert_equal ::Time.new(2013, 8, 27, 20, 30, 40, '-08:00'), Chronic.construct(2013, 8, 27, 20, 30, 40, -28800)
    ensure
      Chronic.time_class = org
    end
  end

  def test_date
    org = Chronic.time_class
    begin
      Chronic.time_class = ::Date
      assert_equal Date.new(2013, 8, 27), Chronic.construct(2013, 8, 27)
    ensure
      Chronic.time_class = org
    end
  end

  def test_datetime
    org = Chronic.time_class
    begin
      Chronic.time_class = ::DateTime
      assert_equal DateTime.new(2013, 8, 27, 20, 30, 40, '+05:30'), Chronic.construct(2013, 8, 27, 20, 30, 40, '+05:30')
      assert_equal DateTime.new(2013, 8, 27, 20, 30, 40, '-08:00'), Chronic.construct(2013, 8, 27, 20, 30, 40, -28800)
    ensure
      Chronic.time_class = org
    end
  end

  def test_activesupport
=begin
    # ActiveSupport needs MiniTest '~> 4.2' which conflicts with '~> 5.0'
    require 'active_support/time'
    org = Chronic.time_class
    org_zone = ::Time.zone
    begin
      ::Time.zone = "Tokyo"
      Chronic.time_class = ::Time.zone
      assert_equal Time.new(2013, 8, 27, 20, 30, 40, '+09:00'), Chronic.construct(2013, 8, 27, 20, 30, 40)
      ::Time.zone = "Indiana (East)"
      Chronic.time_class = ::Time.zone
      assert_equal Time.new(2013, 8, 27, 20, 30, 40, -14400), Chronic.construct(2013, 8, 27, 20, 30, 40)
    ensure
      Chronic.time_class = org
      ::Time.zone = org_zone
    end
=end
  end
end
