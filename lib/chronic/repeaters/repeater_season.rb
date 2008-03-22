class Time
  def to_minidate
    MiniDate.new(self.month, self.day)
  end
end

class Season
  attr_reader :start, :end
  
  def initialize(myStart, myEnd)
    @start = myStart
    @end = myEnd
  end
  
  def self.find_next_season(season, pointer)
    lookup = {:spring => 0, :summer => 1, :autumn => 2, :winter => 3}
    next_season_num = (lookup[season]+1*pointer) % 4
    lookup.invert[next_season_num]
  end
  
  def self.season_after(season); find_next_season(season, +1); end
  def self.season_before(season); find_next_season(season, -1); end
end

class MiniDate
  attr_accessor :month, :day
  
  def initialize(month, day)
    @month = month
    @day = day
  end
  
  def is_between?(md_start, md_end)
    return true if (@month == md_start.month and @day >= md_start.day) ||
                   (@month == md_end.month and @day <= md_end.day)
    
    i = md_start.month + 1
    until i == md_end.month
      return true if @month == i
      i = (i+1) % 12
    end
    
    return false
  end
  
  def equals?(other)
    @month == other.month and day == other.day
  end
end

class Chronic::RepeaterSeason < Chronic::Repeater #:nodoc:
  YEAR_SEASONS = 4
  SEASON_SECONDS = 7_862_400 # 91 * 24 * 60 * 60
  SEASONS = { :spring => Season.new( MiniDate.new(3,20),MiniDate.new(6,20) ),
              :summer => Season.new( MiniDate.new(6,21),MiniDate.new(9,22) ),
              :autumn => Season.new( MiniDate.new(9,23),MiniDate.new(12,21) ),
              :winter => Season.new( MiniDate.new(12,22),MiniDate.new(3,19) ) }

  def initialize(type)
    super
    @next_season_start = nil
  end

  def next(pointer)
    super
    
    direction = pointer == :future ? 1 : -1
    next_season = Season.find_next_season(find_current_season(@now.to_minidate), direction)

    find_next_season_span(direction, next_season)
  end
  
  def this(pointer = :future)
    super
    
    direction = pointer == :future ? 1 : -1

    today = Time.construct(@now.year, @now.month, @now.day)
    this_ssn = find_current_season(@now.to_minidate)
    case pointer
    when :past
      this_ssn_start = today + direction * num_seconds_til_start(this_ssn, direction)
      this_ssn_end = today
    when :future
      this_ssn_start = today + Chronic::RepeaterDay::DAY_SECONDS
      this_ssn_end = today + direction * num_seconds_til_end(this_ssn, direction)
    when :none
      this_ssn_start = today + direction * num_seconds_til_start(this_ssn, direction)
      this_ssn_end = today + direction * num_seconds_til_end(this_ssn, direction)
    end
    
    Chronic::Span.new(this_ssn_start, this_ssn_end)
  end
  
  def offset(span, amount, pointer)
    Chronic::Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
  end
  
  def offset_by(time, amount, pointer) 
    direction = pointer == :future ? 1 : -1
    time + amount * direction * SEASON_SECONDS
  end
  
  def width
    SEASON_SECONDS
  end
  
  def to_s
    super << '-season'
  end
  
  private
  
  def find_next_season_span(direction, next_season)
    if !@next_season_start or !@next_season_end
      @next_season_start = Time.construct(@now.year, @now.month, @now.day)
      @next_season_end = Time.construct(@now.year, @now.month, @now.day)
    end
  
    @next_season_start += direction * num_seconds_til_start(next_season, direction)
    @next_season_end += direction * num_seconds_til_end(next_season, direction)
    
    Chronic::Span.new(@next_season_start, @next_season_end)
  end
  
  def find_current_season(md)
    [:spring, :summer, :autumn, :winter].each do |season|
      return season if md.is_between?(SEASONS[season].start, SEASONS[season].end)
    end
  end
  
  def num_seconds_til(goal, direction)
    start = Time.construct(@now.year, @now.month, @now.day)
    seconds = 0
    
    until (start + direction * seconds).to_minidate.equals?(goal)
      seconds += Chronic::RepeaterDay::DAY_SECONDS
    end

    seconds
  end
  
  def num_seconds_til_start(season_symbol, direction)
    num_seconds_til(SEASONS[season_symbol].start, direction)
  end
  
  def num_seconds_til_end(season_symbol, direction)
    num_seconds_til(SEASONS[season_symbol].end, direction)
  end
end