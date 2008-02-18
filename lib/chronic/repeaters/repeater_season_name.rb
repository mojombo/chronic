require 'chronic/repeaters/repeater_season.rb'

class Chronic::RepeaterSeasonName < Chronic::RepeaterSeason #:nodoc:
  SEASON_SECONDS = 7_862_400 # 91 * 24 * 60 * 60
  DAY_SECONDS = 86_400 # (24 * 60 * 60)
  
  def next(pointer)
    direction = pointer == :future ? 1 : -1
    find_next_season_span(direction, @type)
  end
  
  def this(pointer = :future)
    # super
    
    direction = pointer == :future ? 1 : -1

    today = Time.construct(@now.year, @now.month, @now.day)
    goal_ssn_start = today + direction * num_seconds_til_start(@type, direction)
    goal_ssn_end = today + direction * num_seconds_til_end(@type, direction)
    curr_ssn = find_current_season(@now.to_minidate)
    case pointer
    when :past
      this_ssn_start = goal_ssn_start
      this_ssn_end = (curr_ssn == @type) ? today : goal_ssn_end
    when :future
      this_ssn_start = (curr_ssn == @type) ? today + Chronic::RepeaterDay::DAY_SECONDS : goal_ssn_start
      this_ssn_end = goal_ssn_end
    when :none
      this_ssn_start = goal_ssn_start
      this_ssn_end = goal_ssn_end
    end
    
    Chronic::Span.new(this_ssn_start, this_ssn_end)
  end
  
  def offset(span, amount, pointer)
    Chronic::Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
  end
  
  def offset_by(time, amount, pointer) 
    direction = pointer == :future ? 1 : -1
    time + amount * direction * Chronic::RepeaterYear::YEAR_SECONDS
  end

end