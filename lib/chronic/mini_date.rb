module Chronic
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
end