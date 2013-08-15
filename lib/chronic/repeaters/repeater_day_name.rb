module Chronic
  class RepeaterDayName < Repeater #:nodoc:
    DAY_SECONDS = 86400 # (24 * 60 * 60)

    def initialize(type, options = {})
      super
      @current_date = nil
    end

    def next(pointer)
      super

      direction = pointer == :future ? 1 : -1

      unless @current_date
        @current_date = ::Date.new(@now.year, @now.month, @now.day)
        @current_date += direction

        day_num = symbol_to_number(@type)

        while @current_date.wday != day_num
          @current_date += direction
        end
      else
        @current_date += direction * 7
      end
      next_date = @current_date.succ
      Span.new(Chronic.construct(@current_date.year, @current_date.month, @current_date.day), Chronic.construct(next_date.year, next_date.month, next_date.day))
    end

    def this(pointer = :future)
      super

      pointer = :future if pointer == :none
      self.next(pointer)
    end

    def width
      DAY_SECONDS
    end

    def to_s
      super << '-dayname-' << @type.to_s
    end

    private

    def symbol_to_number(sym)
      lookup = {:sunday => 0, :monday => 1, :tuesday => 2, :wednesday => 3, :thursday => 4, :friday => 5, :saturday => 6}
      lookup[sym] || raise("Invalid symbol specified")
    end
  end
end
