class Chronic::RepeaterMinute < Chronic::Repeater #:nodoc:
  MINUTE_SECONDS = 60
  
  def this(pointer = :future)
    minute_begin = Time.local(@now.year, @now.month, @now.day, @now.hour, @now.min)
    Chronic::Span.new(minute_begin, minute_begin + MINUTE_SECONDS)
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    span + direction * amount * MINUTE_SECONDS
  end
  
  def width
    MINUTE_SECONDS
  end
  
  def to_s
    super << '-minute'
  end
end