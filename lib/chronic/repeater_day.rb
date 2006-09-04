class Chronic::RepeaterDay < Chronic::Repeater #:nodoc:
  DAY_SECONDS = 86400 # (24 * 60 * 60)
  
  def next(pointer)
    super
    
    @current_day ||= Date.parse(@now.to_s)
    @current_day += pointer == :future ? 1 : -1
    span_begin = Time.parse(@current_day.to_s)
    Chronic::Span.new(span_begin, span_begin + width)
  end
  
  def this(pointer = :future)
    super
    
    @current_day ||= Date.parse(@now.to_s)
    span_begin = Time.parse(@current_day.to_s)
    Chronic::Span.new(span_begin, span_begin + width)
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    span + direction * amount * DAY_SECONDS
  end
  
  def width
    DAY_SECONDS
  end
  
  def to_s
    super << '-day'
  end
end