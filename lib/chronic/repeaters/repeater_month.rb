class Chronic::RepeaterMonth < Chronic::Repeater #:nodoc:
  MONTH_SECONDS = 2_592_000 # 30 * 24 * 60 * 60
  YEAR_MONTHS = 12
  
  def next(pointer)
    super
    
    if !@current_month_start
      @current_month_start = offset_by(Time.construct(@now.year, @now.month), 1, pointer)
    else
      @current_month_start = offset_by(Time.construct(@current_month_start.year, @current_month_start.month), 1, pointer)
    end
    
    Chronic::Span.new(@current_month_start, Time.construct(@current_month_start.year, @current_month_start.month + 1))
  end
  
  def this(pointer = :future)
    super
    
    case pointer
    when :future
      month_start = Time.construct(@now.year, @now.month, @now.day + 1)
      month_end = self.offset_by(Time.construct(@now.year, @now.month), 1, :future)
    when :past
      month_start = Time.construct(@now.year, @now.month)
      month_end = Time.construct(@now.year, @now.month, @now.day)
    when :none
      month_start = Time.construct(@now.year, @now.month)
      month_end = self.offset_by(Time.construct(@now.year, @now.month), 1, :future)
    end
    
    Chronic::Span.new(month_start, month_end)
  end
  
  def offset(span, amount, pointer)      
    Chronic::Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
  end
  
  def offset_by(time, amount, pointer) 
    direction = pointer == :future ? 1 : -1
    
    amount_years = direction * amount / YEAR_MONTHS
    amount_months = direction * amount % YEAR_MONTHS
    
    new_year = time.year + amount_years
    new_month = time.month + amount_months
    if new_month > YEAR_MONTHS
      new_year += 1
      new_month -= YEAR_MONTHS
    end
    Time.construct(new_year, new_month, time.day, time.hour, time.min, time.sec)
  end
  
  def width
    MONTH_SECONDS
  end
  
  def to_s
    super << '-month'
  end
end