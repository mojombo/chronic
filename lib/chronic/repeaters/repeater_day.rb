class Chronic::RepeaterDay < Chronic::Repeater #:nodoc:
  DAY_SECONDS = 86_400 # (24 * 60 * 60)
  
  def next(pointer)
    super
    
    if !@current_day_start
      @current_day_start = Time.local(@now.year, @now.month, @now.day)
    end
    
    direction = pointer == :future ? 1 : -1
    @current_day_start += direction * DAY_SECONDS
    
    Chronic::Span.new(@current_day_start, @current_day_start + DAY_SECONDS)
  end
  
  def this(pointer = :future)
    super
    
    case pointer
    when :future
      day_begin = Time.construct(@now.year, @now.month, @now.day, @now.hour + 1)
      day_end = Time.construct(@now.year, @now.month, @now.day) + DAY_SECONDS
    when :past
      day_begin = Time.construct(@now.year, @now.month, @now.day)
      day_end = Time.construct(@now.year, @now.month, @now.day, @now.hour)
    when :none
      day_begin = Time.construct(@now.year, @now.month, @now.day)
      day_end = Time.construct(@now.year, @now.month, @now.day) + DAY_SECONDS
    end
    
    Chronic::Span.new(day_begin, day_end)
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