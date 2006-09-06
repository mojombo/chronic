class Chronic::RepeaterTime < Chronic::Repeater #:nodoc:
  class Tick #:nodoc:
    attr_accessor :time
    
    def initialize(time, ambiguous = false)
      @time = time
      @ambiguous = ambiguous
    end
    
    def ambiguous?
      @ambiguous
    end
    
    def *(other)
      Tick.new(@time * other, @ambiguous)
    end
    
    def to_f
      @time.to_f
    end
    
    def to_s
      @time.to_s + (@ambiguous ? '?' : '')
    end
  end
  
  def initialize(time, options = {})
    t = time.sub(/\:/, '')
    @type = 
    if (1..2) === t.size
      Tick.new(t.to_i * 60 * 60, true)
    elsif t.size == 3
      Tick.new((t[0..0].to_i * 60 * 60) + (t[1..2].to_i * 60), true)
    elsif t.size == 4
      ambiguous = time =~ /:/ && t[0..0].to_i != 0 && t[0..1].to_i <= 12
      Tick.new(t[0..1].to_i * 60 * 60 + t[2..3].to_i * 60, ambiguous)
    else
      raise("Time cannot exceed four digits")
    end
  end
  
  # Return the next past or future Span for the time that this Repeater represents
  #   pointer - Symbol representing which temporal direction to fetch the next day
  #             must be either :past or :future
  def next(pointer)
    super
    
    half_day = 60 * 60 * 12
    full_day = 60 * 60 * 24
    
    first = false
    
    unless @current_time
      first = true
      midnight = Time.local(@now.year, @now.month, @now.day)
      yesterday_midnight = midnight - full_day
      tomorrow_midnight = midnight + full_day

      catch :done do
        if pointer == :future
          if @type.ambiguous?
            [midnight + @type, midnight + half_day + @type, tomorrow_midnight + @type].each do |t|
              (@current_time = t; throw :done) if t > @now
            end
          else
            [midnight + @type, tomorrow_midnight + @type].each do |t|
              (@current_time = t; throw :done) if t > @now
            end
          end
        else # pointer == :past
          if @type.ambiguous?
            [midnight + half_day + @type, midnight + @type, yesterday_midnight + @type * 2].each do |t|
              (@current_time = t; throw :done) if t < @now
            end
          else
            [midnight + @type, yesterday_midnight + @type].each do |t|
              (@current_time = t; throw :done) if t < @now
            end
          end
        end
      end
      
      @current_time || raise("Current time cannot be nil at this point")
    end
    
    unless first
      increment = @type.ambiguous? ? half_day : full_day
      @current_time += pointer == :future ? increment : -increment
    end
    
    Chronic::Span.new(@current_time, @current_time + width)
  end
  
  def this(context = :future)
    [:future, :past].include?(context) || raise("First argument 'context' must be one of :past or :future")
    self.next(context)
  end
  
  def width
    1
  end
  
  def to_s
    super << '-time-' << @type.to_s
  end
end