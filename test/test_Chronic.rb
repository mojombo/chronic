require 'helper'

class TestChronic < Test::Unit::TestCase

  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_pre_normalize_numerized_string
    string = 'two and a half years'
    assert_equal Chronic::Numerizer.numerize(string), Chronic.pre_normalize(string)
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
    assert_equal Time.local(2006, 8, 16, 12), Chronic.guess(span)

    span = Chronic::Span.new(Time.local(2006, 8, 16, 0), Time.local(2006, 8, 17, 0, 0, 1))
    assert_equal Time.local(2006, 8, 16, 12), Chronic.guess(span)

    span = Chronic::Span.new(Time.local(2006, 11), Time.local(2006, 12))
    assert_equal Time.local(2006, 11, 16), Chronic.guess(span)
  end

  def test_now
    Chronic.parse('now', :now => Time.local(2006, 01))
    assert_equal Time.local(2006, 01), Chronic.now

    Chronic.parse('now', :now => Time.local(2007, 01))
    assert_equal Time.local(2007, 01), Chronic.now
  end

  def test_endian_definitions
    # middle, little
    endians = [
      Chronic::Handler.new([:scalar_month, :separator_slash_or_dash, :scalar_day, :separator_slash_or_dash, :scalar_year, :separator_at?, 'time?'], :handle_sm_sd_sy),
      Chronic::Handler.new([:scalar_day, :separator_slash_or_dash, :scalar_month, :separator_slash_or_dash, :scalar_year, :separator_at?, 'time?'], :handle_sd_sm_sy)
    ]

    assert_equal endians, Chronic.definitions[:endian]

    defs = Chronic.definitions(:endian_precedence => :little)
    assert_equal endians.reverse, defs[:endian]

    defs = Chronic.definitions(:endian_precedence => [:little, :middle])
    assert_equal endians.reverse, defs[:endian]

    assert_raises(ArgumentError) do
      Chronic.definitions(:endian_precedence => :invalid)
    end
  end

  def test_passing_options
    assert_raises(ArgumentError) do
      Chronic.parse('now', :invalid => :option)
    end

    assert_raises(ArgumentError) do
      Chronic.parse('now', :context => :invalid_context)
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

    assert_nothing_raised do
      Chronic.construct(2006, 1, 56)
    end

    assert_raise(RuntimeError) do
      Chronic.construct(2006, 1, 57)
    end
  end

  def test_month_overflow
    assert_equal Time.local(2006, 1), Chronic.construct(2005, 13)
    assert_equal Time.local(2005, 12), Chronic.construct(2000, 72)
  end

end
