class Chronic::RepeaterSeason < Chronic::Repeater #:nodoc:
  SEASON_SECONDS = 7_862_400 # 91 * 24 * 60 * 60
  
  def next(pointer)
    super
    
    raise 'Not implemented'
  end
  
  def this(pointer = :future)
    super
    
    raise 'Not implemented'
  end
  
  def width
    SEASON_SECONDS
  end
  
  def to_s
    super << '-season'
  end
end