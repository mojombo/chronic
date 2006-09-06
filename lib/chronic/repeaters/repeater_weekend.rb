class Chronic::RepeaterWeekend < Chronic::Repeater #:nodoc:
  WEEKEND_SECONDS = 172_800 # (2 * 24 * 60 * 60)
  
  def width
    WEEKEND_SECONDS
  end
  
  def to_s
    super << '-weekend'
  end
end