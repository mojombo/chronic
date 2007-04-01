class Chronic::RepeaterYear < Chronic::Repeater #:nodoc:
  
  def next(pointer)
    super
    
    if !@current_year_start
      case pointer
      when :future
        @current_year_start = Time.construct(@now.year + 1)
      when :past
        @current_year_start = Time.construct(@now.year - 1)
      end
    else
      diff = pointer == :future ? 1 : -1
      @current_year_start = Time.construct(@current_year_start.year + diff)
    end
    
    Chronic::Span.new(@current_year_start, Time.construct(@current_year_start.year + 1))
  end
  
  def this(pointer = :future)
    super
    
    case pointer
    when :future
      this_year_start = Time.construct(@now.year, @now.month, @now.day) + Chronic::RepeaterDay::DAY_SECONDS
      this_year_end = Time.construct(@now.year + 1, 1, 1)
    when :past
      this_year_start = Time.construct(@now.year, 1, 1)
      this_year_end = Time.construct(@now.year, @now.month, @now.day)
    when :none
      this_year_start = Time.construct(@now.year, 1, 1)
      this_year_end = Time.construct(@now.year + 1, 1, 1)
    end
    
    Chronic::Span.new(this_year_start, this_year_end)
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    
    sb = span.begin
    new_begin = Time.construct(sb.year + (amount * direction), sb.month, sb.day, sb.hour, sb.min, sb.sec)
    
    se = span.end
    new_end = Time.construct(se.year + (amount * direction), se.month, se.day, se.hour, se.min, se.sec)
    
    Chronic::Span.new(new_begin, new_end)
  end
  
  def width
    (365 * 24 * 60 * 60)
  end
  
  def to_s
    super << '-year'
  end
end