class Chronic::RepeaterDayName < Chronic::Repeater #:nodoc:
  DAY_SECONDS = 86400 # (24 * 60 * 60)
  
  def next(pointer)
    super
    
    direction = pointer == :future ? 1 : -1
    
    if !@current_day_start
      @current_day_start = Time.construct(@now.year, @now.month, @now.day)
      @current_day_start += direction * DAY_SECONDS

      day_num = symbol_to_number(@type)
      
      while @current_day_start.wday != day_num
        @current_day_start += direction * DAY_SECONDS
      end
    else
      @current_day_start += direction * 7 * DAY_SECONDS
    end
    
    Chronic::Span.new(@current_day_start, @current_day_start + DAY_SECONDS)
  end
  
  def this(pointer = :future)
    super
    
    pointer = :future if pointer == :none
    self.next(pointer)
  end
  
  def width
    DAY_SECONDS
  end
  
  def to_s
    super << '-dayname-' << @type.to_s
  end
  
  private
  
  def symbol_to_number(sym)
    lookup = {:sunday => 0, :monday => 1, :tuesday => 2, :wednesday => 3, :thursday => 4, :friday => 5, :saturday => 6}
    lookup[sym] || raise("Invalid symbol specified")
  end
end