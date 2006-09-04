class Chronic::RepeaterMonth < Chronic::Repeater #:nodoc:
  def width
    30 * 24 * 60 * 60
  end
  
  def next(pointer)
    super
    
    if !@current_month_start
      @current_month_start = offset_by(Time.local(@now.year, @now.month), 1, pointer)
    else
      @current_month_start = offset_by(Time.local(@current_month_start.year, @current_month_start.month), 1, pointer)
    end
    
    Chronic::Span.new(@current_month_start, Time.local(@current_month_start.year, @current_month_start.month + 1))
  end
  
  def this(pointer = :future)
    super
    raise 'Not implemented'
  end
  
  def offset(span, amount, pointer)      
    Chronic::Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
  end
  
  def offset_by(time, amount, pointer)
    direction = pointer == :future ? 1 : -1
    
    amount_years = direction * amount / 12
    amount_months = direction * amount % 12
    
    new_year = time.year + amount_years
    new_month = time.month + amount_months
    if new_month > 12
      new_year += 1
      new_month -= 12
    end
    Time.local(new_year, new_month, time.day, time.hour, time.min, time.sec)
  end
end