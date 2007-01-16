class Chronic::RepeaterWeekend < Chronic::Repeater #:nodoc:
  WEEKEND_SECONDS = 172_800 # (2 * 24 * 60 * 60)
  
  def next(pointer)
    super
    
    if !@current_week_start
      case pointer
      when :future
        saturday_repeater = Chronic::RepeaterDayName.new(:saturday)
        saturday_repeater.start = @now
        next_saturday_span = saturday_repeater.next(:future)
        @current_week_start = next_saturday_span.begin
      when :past
        saturday_repeater = Chronic::RepeaterDayName.new(:saturday)
        saturday_repeater.start = (@now + Chronic::RepeaterDay::DAY_SECONDS)
        last_saturday_span = saturday_repeater.next(:past)
        @current_week_start = last_saturday_span.begin
      end
    else
      direction = pointer == :future ? 1 : -1
      @current_week_start += direction * Chronic::RepeaterWeek::WEEK_SECONDS
    end
    
    Chronic::Span.new(@current_week_start, @current_week_start + WEEKEND_SECONDS)
  end
  
  def this(pointer = :future)
    super
    
    case pointer
    when :future, :none
      saturday_repeater = Chronic::RepeaterDayName.new(:saturday)
      saturday_repeater.start = @now
      this_saturday_span = saturday_repeater.this(:future)
      Chronic::Span.new(this_saturday_span.begin, this_saturday_span.begin + WEEKEND_SECONDS)
    when :past
      saturday_repeater = Chronic::RepeaterDayName.new(:saturday)
      saturday_repeater.start = @now
      last_saturday_span = saturday_repeater.this(:past)
      Chronic::Span.new(last_saturday_span.begin, last_saturday_span.begin + WEEKEND_SECONDS)
    end
  end
  
  def offset(span, amount, pointer)
    direction = pointer == :future ? 1 : -1
    weekend = Chronic::RepeaterWeekend.new(:weekend)
    weekend.start = span.begin
    start = weekend.next(pointer).begin + (amount - 1) * direction * Chronic::RepeaterWeek::WEEK_SECONDS
    Chronic::Span.new(start, start + (span.end - span.begin))
  end
  
  def width
    WEEKEND_SECONDS
  end
  
  def to_s
    super << '-weekend'
  end
end