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
      lookup = [:spring, :summer, :autumn, :winter]
      next_season_num = (lookup.index(season) + 1 * pointer) % 4
      lookup[next_season_num]
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
end