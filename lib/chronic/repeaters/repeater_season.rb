module Chronic
  class Season
    # @return [MiniDate]
    attr_reader :start

    # @return [MiniDate]
    attr_reader :end

    # @param [MiniDate] start_date
    # @param [MiniDate] end_date
    def initialize(start_date, end_date)
      @start = start_date
      @end = end_date
    end

    # @param [Symbol]  season  The season name
    # @param [Integer] pointer The direction (-1 for past, 1 for future)
    # @return [Symbol] The new season name
    def self.find_next_season(season, pointer)
      lookup = {:spring => 0, :summer => 1, :autumn => 2, :winter => 3}
      next_season_num = (lookup[season] + 1 * pointer) % 4
      lookup.invert[next_season_num]
    end

    # @param [Symbol] season The season name
    # @return [Symbol] The new season name
    def self.season_after(season)
      find_next_season(season, +1)
    end

    # @param [Symbol] season The season name
    # @return [Symbol] The new season name
    def self.season_before(season)
      find_next_season(season, -1)
    end
  end

  class RepeaterSeason < Repeater #:nodoc:
    SEASON_SECONDS = 7_862_400 # 91 * 24 * 60 * 60
    SEASONS = {
      :spring => Season.new(MiniDate.new(3,20), MiniDate.new(6,20)),
      :summer => Season.new(MiniDate.new(6,21), MiniDate.new(9,22)),
      :autumn => Season.new(MiniDate.new(9,23), MiniDate.new(12,21)),
      :winter => Season.new(MiniDate.new(12,22), MiniDate.new(3,19))
    }

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
        this_ssn_start = today + RepeaterDay::DAY_SECONDS
        this_ssn_end = today + direction * num_seconds_til_end(this_ssn, direction)
      when :none
        this_ssn_start = today + direction * num_seconds_til_start(this_ssn, direction)
        this_ssn_end = today + direction * num_seconds_til_end(this_ssn, direction)
      end

      construct_season(this_ssn_start, this_ssn_end)
    end

    def offset(span, amount, pointer)
      Span.new(offset_by(span.begin, amount, pointer), offset_by(span.end, amount, pointer))
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

      construct_season(@next_season_start, @next_season_end)
    end

    def find_current_season(md)
      [:spring, :summer, :autumn, :winter].find do |season|
        md.is_between?(SEASONS[season].start, SEASONS[season].end)
      end
    end

    def num_seconds_til(goal, direction)
      start = Time.construct(@now.year, @now.month, @now.day)
      seconds = 0

      until (start + direction * seconds).to_minidate.equals?(goal)
        seconds += RepeaterDay::DAY_SECONDS
      end

      seconds
    end

    def num_seconds_til_start(season_symbol, direction)
      num_seconds_til(SEASONS[season_symbol].start, direction)
    end

    def num_seconds_til_end(season_symbol, direction)
      num_seconds_til(SEASONS[season_symbol].end, direction)
    end

    def construct_season(start, finish)
      Span.new(
        Time.construct(start.year, start.month, start.day),
        Time.construct(finish.year, finish.month, finish.day)
      )
    end
  end
end