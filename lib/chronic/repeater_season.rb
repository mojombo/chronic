class Chronic::RepeaterSeason < Chronic::Repeater #:nodoc:
  def next(pointer)
    super
    raise 'Not implemented'
  end
  
  def this(pointer = :future)
    super
    raise 'Not implemented'
  end
  
  def width
    (91 * 24 * 60 * 60)
  end
  
  def to_s
    super << '-season'
  end
end