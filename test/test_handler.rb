require_relative 'helper'

class TestHandler < TestCase

  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def definitions
    @definitions ||= Chronic::SpanDictionary.new.definitions
  end

  def test_handler_class_1
    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::DayName.new(:friday))

    assert Chronic::Handler.match(tokens, 0, [Chronic::DayName])

    tokens << Chronic::Token.new('afternoon')
    tokens[1].tag(Chronic::TimeSpecial.new(:afternoon))

    assert !Chronic::Handler.match(tokens, 1, [Chronic::DayName])
  end

  def test_handler_class_2
    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::DayName.new(:friday))

    assert !Chronic::Handler.match(tokens, 0, [Chronic::TimeSpecial])

    tokens << Chronic::Token.new('afternoon')
    tokens[1].tag(Chronic::TimeSpecial.new(:afternoon))

    assert Chronic::Handler.match(tokens, 1, [Chronic::TimeSpecial])

    tokens << Chronic::Token.new('afternoon')
    tokens[2].tag(Chronic::TimeSpecial.new(:afternoon))

    assert Chronic::Handler.match(tokens, 1, [Chronic::TimeSpecial, Chronic::TimeSpecial])
  end

  def test_handler_class_3
    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::DayName.new(:friday))

    assert !Chronic::Handler.match(tokens, 0, [Chronic::DayName, Chronic::TimeSpecial])

    tokens << Chronic::Token.new('afternoon')
    tokens[1].tag(Chronic::TimeSpecial.new(:afternoon))

    assert Chronic::Handler.match(tokens, 0, [Chronic::DayName, Chronic::TimeSpecial])
  end

  def test_handler_class_4
    tokens = [Chronic::Token.new('may')]
    tokens[0].tag(Chronic::MonthName.new(:may))

    assert !Chronic::Handler.match(tokens, 0, [Chronic::MonthName, Chronic::ScalarDay])

    tokens << Chronic::Token.new('27')
    tokens[1].tag(Chronic::ScalarDay.new(27))

    assert Chronic::Handler.match(tokens, 0, [Chronic::MonthName, Chronic::ScalarDay])
  end

  def test_handler_class_5
    tokens = [Chronic::Token.new('friday')]
    tokens[0].tag(Chronic::DayName.new(:friday))

    assert !Chronic::Handler.match(tokens, 0, [Chronic::DayName, Chronic::ScalarHour])

    tokens << Chronic::Token.new('5')
    tokens[1].tag(Chronic::ScalarHour.new('5'))

    assert Chronic::Handler.match(tokens, 0, [Chronic::DayName, Chronic::ScalarHour])

    tokens << Chronic::Token.new('pm')
    tokens[2].tag(Chronic::DayPortion.new(:pm))

    assert Chronic::Handler.match(tokens, 0, [Chronic::DayName, Chronic::ScalarHour, Chronic::DayPortion])
  end

  def test_handler_class_6
    tokens = [Chronic::Token.new('3'),
              Chronic::Token.new('years'),
              Chronic::Token.new('past')]

    tokens[0].tag(Chronic::Scalar.new(3))
    tokens[1].tag(Chronic::UnitYear.new(:year))
    tokens[2].tag(Chronic::Pointer.new(:past))

    assert Chronic::Handler.match(tokens, 0, [Chronic::Scalar, Chronic::UnitYear, Chronic::Pointer])
  end

  def test_handler_class_7
    tokens = [Chronic::Token.new('at'),
              Chronic::Token.new('14')]

    tokens[0].tag(Chronic::SeparatorAt.new('at'))
    tokens[1].tag(Chronic::Scalar.new(14))

    assert Chronic::Handler.match(tokens, 0, [Chronic::SeparatorAt, Chronic::Scalar])

    tokens = [Chronic::Token.new('on'),
              Chronic::Token.new('15')]

    tokens[0].tag(Chronic::SeparatorOn.new('on'))
    tokens[1].tag(Chronic::Scalar.new(15))

    assert Chronic::Handler.match(tokens, 0, [Chronic::SeparatorOn, Chronic::Scalar])
  end
end
