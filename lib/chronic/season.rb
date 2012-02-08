module Chronic
  class Season

    attr_reader :start
    attr_reader :end

    def initialize(start_date, end_date)
      @start = start_date
      @end = end_date
    end

    def self.find_next_season(season, pointer)
      lookup = [:spring, :summer, :autumn, :winter]
      next_season_num = (lookup.index(season) + 1 * pointer) % 4
      lookup[next_season_num]
    end

    def self.season_after(season)
      find_next_season(season, +1)
    end

    def self.season_before(season)
      find_next_season(season, -1)
    end
  end
end