class Chronic::RepeaterSeasonName < Chronic::RepeaterSeason #:nodoc:
  @summer = ['jul 21', 'sep 22']
  @autumn = ['sep 23', 'dec 21']
  @winter = ['dec 22', 'mar 19']
  @spring = ['mar 20', 'jul 20']
  
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
    super << '-season-' << @type.to_s
  end
end