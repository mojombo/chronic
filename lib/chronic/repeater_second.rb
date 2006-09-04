class Chronic::RepeaterSecond < Chronic::Repeater #:nodoc:
  SECOND_SECONDS = 1 # haha, awesome
  
  def this(pointer = :future)
    Chronic::Span.new(@now, @now + 1)
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    span + direction * amount * SECOND_SECONDS
  end
  
  def width
    SECOND_SECONDS
  end
  
  def to_s
    super << '-second'
  end
end