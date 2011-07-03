require 'helper'

class TestHandler < Test::Unit::TestCase

  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_handler_class_1
    handler = Chronic::Handler.new([:repeater], :handler)

    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::RepeaterDayName.new(:friday))

    assert handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('afternoon')
    tokens[1].tag(Chronic::RepeaterDayPortion.new(:afternoon))

    assert !handler.match(tokens, Chronic.definitions)
  end

  def test_handler_class_2
    handler = Chronic::Handler.new([:repeater, :repeater?], :handler)

    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::RepeaterDayName.new(:friday))

    assert handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('afternoon')
    tokens[1].tag(Chronic::RepeaterDayPortion.new(:afternoon))

    assert handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('afternoon')
    tokens[2].tag(Chronic::RepeaterDayPortion.new(:afternoon))

    assert !handler.match(tokens, Chronic.definitions)
  end

  def test_handler_class_3
    handler = Chronic::Handler.new([:repeater, 'time?'], :handler)

    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::RepeaterDayName.new(:friday))

    assert handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('afternoon')
    tokens[1].tag(Chronic::RepeaterDayPortion.new(:afternoon))

    assert !handler.match(tokens, Chronic.definitions)
  end

  def test_handler_class_4
    handler = Chronic::Handler.new([:repeater_month_name, :scalar_day, 'time?'], :handler)

    tokens = [Chronic::Token.new('may')]
    tokens[0].tag(Chronic::RepeaterMonthName.new(:may))

    assert !handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('27')
    tokens[1].tag(Chronic::ScalarDay.new(27))

    assert handler.match(tokens, Chronic.definitions)
  end

  def test_handler_class_5
    handler = Chronic::Handler.new([:repeater, 'time?'], :handler)

    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::RepeaterDayName.new(:friday))

    assert handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('5:00')
    tokens[1].tag(Chronic::RepeaterTime.new('5:00'))

    assert handler.match(tokens, Chronic.definitions)

    tokens << Chronic::Token.new('pm')
    tokens[2].tag(Chronic::RepeaterDayPortion.new(:pm))

    assert handler.match(tokens, Chronic.definitions)
  end

  def test_handler_class_6
    handler = Chronic::Handler.new([:scalar, :repeater, :pointer], :handler)

    tokens = [Chronic::Token.new('3'),
              Chronic::Token.new('years'),
              Chronic::Token.new('past')]

    tokens[0].tag(Chronic::Scalar.new(3))
    tokens[1].tag(Chronic::RepeaterYear.new(:year))
    tokens[2].tag(Chronic::Pointer.new(:past))

    assert handler.match(tokens, Chronic.definitions)
  end

end
