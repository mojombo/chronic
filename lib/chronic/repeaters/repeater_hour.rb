class Chronic::RepeaterHour < Chronic::Repeater #:nodoc:
  HOUR_SECONDS = 3600 # 60 * 60
  
  def next(pointer)
    super
    
    if !@current_hour_start
      case pointer
      when :future
        @current_hour_start = Time.construct(@now.year, @now.month, @now.day, @now.hour + 1)
      when :past
        @current_hour_start = Time.construct(@now.year, @now.month, @now.day, @now.hour - 1)
      end
    else
      direction = pointer == :future ? 1 : -1
      @current_hour_start += direction * HOUR_SECONDS
    end
    
    Chronic::Span.new(@current_hour_start, @current_hour_start + HOUR_SECONDS)
  end
  
  def this(pointer = :future)
    super
    
    case pointer
    when :future
      hour_start = Time.construct(@now.year, @now.month, @now.day, @now.hour, @now.min + 1)
      hour_end = Time.construct(@now.year, @now.month, @now.day, @now.hour + 1)
    when :past
      hour_start = Time.construct(@now.year, @now.month, @now.day, @now.hour)
      hour_end = Time.construct(@now.year, @now.month, @now.day, @now.hour, @now.min)
    when :none
      hour_start = Time.construct(@now.year, @now.month, @now.day, @now.hour)
      hour_end = hour_begin + HOUR_SECONDS
    end
    
    Chronic::Span.new(hour_start, hour_end)
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    span + direction * amount * HOUR_SECONDS
  end
  
  def width
    HOUR_SECONDS
  end
  
  def to_s
    super << '-hour'
  end
end