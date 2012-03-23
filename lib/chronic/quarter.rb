module Chronic
  class Quarter

    attr_reader :start
    attr_reader :end

    def initialize(start_date, end_date)
      @start = start_date
      @end = end_date
    end

    def self.find_next_quarter(quarter, pointer)
      lookup = [:first, :second, :third, :fourth]
      next_quarter_num = (lookup.index(quarter) + 1 * pointer) % 4
      lookup[next_quarter_num]
    end

    def self.quarter_after(quarter)
      find_next_quarter(quarter, +1)
    end

    def self.quarter_before(quarter)
      find_next_quarter(quarter, -1)
    end
  end
end