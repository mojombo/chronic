class Chronic::RepeaterMinute < Chronic::Repeater #:nodoc:
  MINUTE_SECONDS = 60
  
  def next(pointer = :future)
    super
    
    direction = pointer == :future ? 1 : -1
    
    raise 'not implemented'
  end
  
  def this(pointer = :future)
    super
    
    case pointer
    when :future
      minute_begin = @now
      minute_end = Time.local(@now.year, @now.month, @now.day, @now.hour, @now.min)
    when :past
      minute_begin = Time.local(@now.year, @now.month, @now.day, @now.hour, @now.min)
      minute_end = @now
    when :none
      minute_begin = Time.local(@now.year, @now.month, @now.day, @now.hour, @now.min)
      minute_end = Time.local(@now.year, @now.month, @now.day, @now.hour, @now.min) + MINUTE_SECONDS
    end
    
    Chronic::Span.new(minute_begin, minute_end)
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