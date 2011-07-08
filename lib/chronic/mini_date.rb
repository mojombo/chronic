module Chronic
  class MiniDate
    attr_accessor :month, :day

    def self.from_time(time)
      new(time.month, time.day)
    end

    def initialize(month, day)
      unless (1..12).include?(month)
        raise ArgumentError, "1..12 are valid months"
      end

      @month = month
      @day = day
    end

    def is_between?(md_start, md_end)
      return false if (@month == md_start.month && @month == md_end.month) &&
                      (@day < md_start.day || @day > md_end.day)
      return true if (@month == md_start.month && @day >= md_start.day) ||
                     (@month == md_end.month && @day <= md_end.day)

      i = (md_start.month % 12) + 1

      until i == md_end.month
        return true if @month == i
        i = (i % 12) + 1
      end

      return false
    end

    def equals?(other)
      @month == other.month and @day == other.day
    end
  end
end