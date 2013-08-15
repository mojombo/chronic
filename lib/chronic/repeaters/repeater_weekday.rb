module Chronic
  class RepeaterWeekday < Repeater #:nodoc:
    DAY_SECONDS = 86400 # (24 * 60 * 60)
    DAYS = {
      :sunday => 0,
      :monday => 1,
      :tuesday => 2,
      :wednesday => 3,
      :thursday => 4,
      :friday => 5,
      :saturday => 6
    }

    def initialize(type, options = {})
      super
      @current_weekday_start = nil
    end

    def next(pointer)
      super

      direction = pointer == :future ? 1 : -1

      unless @current_weekday_start
        @current_weekday_start = Chronic.construct(@now.year, @now.month, @now.day)
        @current_weekday_start += direction * DAY_SECONDS

        until is_weekday?(@current_weekday_start.wday)
          @current_weekday_start += direction * DAY_SECONDS
        end
      else
        loop do
          @current_weekday_start += direction * DAY_SECONDS
          break if is_weekday?(@current_weekday_start.wday)
        end
      end

      Span.new(@current_weekday_start, @current_weekday_start + DAY_SECONDS)
    end

    def this(pointer = :future)
      super

      case pointer
      when :past
        self.next(:past)
      when :future, :none
        self.next(:future)
      end
    end

    def offset(span, amount, pointer)
      direction = pointer == :future ? 1 : -1

      num_weekdays_passed = 0; offset = 0
      until num_weekdays_passed == amount
        offset += direction * DAY_SECONDS
        num_weekdays_passed += 1 if is_weekday?((span.begin+offset).wday)
      end

      span + offset
    end

    def width
      DAY_SECONDS
    end

    def to_s
      super << '-weekday'
    end

    private

    def is_weekend?(day)
      day == symbol_to_number(:saturday) || day == symbol_to_number(:sunday)
    end

    def is_weekday?(day)
      !is_weekend?(day)
    end

    def symbol_to_number(sym)
      DAYS[sym] || raise("Invalid symbol specified")
    end
  end
end
