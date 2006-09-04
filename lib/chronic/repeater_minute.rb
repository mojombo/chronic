class Chronic::RepeaterMinute < Chronic::Repeater #:nodoc:
  def this(pointer = :future)
    minute_begin = Time.local(@now.year, @now.month, @now.day, @now.hour, @now.min)
    Chronic::Span.new(minute_begin, minute_begin + 60)
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    span + direction * amount * 60
  end
  
  def width
    60
  end
  
  def to_s
    super << '-minute'
  end
end