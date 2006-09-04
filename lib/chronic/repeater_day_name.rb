class Chronic::RepeaterDayName < Chronic::Repeater #:nodoc:
  
  def next(pointer)
    super
    
    if !@current_day
      @current_day = Date.parse(@now.to_s)
      @current_day += pointer == :future ? 1 : -1
      day_num = symbol_to_number(@type)
      while @current_day.wday != day_num
        @current_day += pointer == :future ? 1 : -1
      end
    else
      @current_day += pointer == :future ? 7 : -7
    end
    span_begin = Time.parse(@current_day.to_s)
    Chronic::Span.new(span_begin, span_begin + width)
  end
  
  def this(pointer = :future)
    super
    
    self.next(:future)
  end
  
  def width
    (60 * 60 * 24)
  end
  
  def to_s
    super << '-dayofweek-' << @type.to_s
  end
  
  private
  
  def symbol_to_number(sym)
    lookup = {:sunday => 0, :monday => 1, :tuesday => 2, :wednesday => 3, :thursday => 4, :friday => 5, :saturday => 6}
    lookup[sym] || raise("Invalid symbol specified")
  end
end