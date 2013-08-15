module Chronic
  class RepeaterMonthName < Repeater #:nodoc:
    MONTH_SECONDS = 2_592_000 # 30 * 24 * 60 * 60
    MONTHS = {
      :january => 1,
      :february => 2,
      :march => 3,
      :april => 4,
      :may => 5,
      :june => 6,
      :july => 7,
      :august => 8,
      :september => 9,
      :october => 10,
      :november => 11,
      :december => 12
    }

    def initialize(type, options = {})
      super
      @current_month_begin = nil
    end

    def next(pointer)
      super

      unless @current_month_begin
        case pointer
        when :future
          if @now.month < index
            @current_month_begin = Chronic.construct(@now.year, index)
          elsif @now.month > index
            @current_month_begin = Chronic.construct(@now.year + 1, index)
          end
        when :none
          if @now.month <= index
            @current_month_begin = Chronic.construct(@now.year, index)
          elsif @now.month > index
            @current_month_begin = Chronic.construct(@now.year + 1, index)
          end
        when :past
          if @now.month >= index
            @current_month_begin = Chronic.construct(@now.year, index)
          elsif @now.month < index
            @current_month_begin = Chronic.construct(@now.year - 1, index)
          end
        end
        @current_month_begin || raise("Current month should be set by now")
      else
        case pointer
        when :future
          @current_month_begin = Chronic.construct(@current_month_begin.year + 1, @current_month_begin.month)
        when :past
          @current_month_begin = Chronic.construct(@current_month_begin.year - 1, @current_month_begin.month)
        end
      end

      cur_month_year = @current_month_begin.year
      cur_month_month = @current_month_begin.month

      if cur_month_month == 12
        next_month_year = cur_month_year + 1
        next_month_month = 1
      else
        next_month_year = cur_month_year
        next_month_month = cur_month_month + 1
      end

      Span.new(@current_month_begin, Chronic.construct(next_month_year, next_month_month))
    end

    def this(pointer = :future)
      super

      case pointer
      when :past
        self.next(pointer)
      when :future, :none
        self.next(:none)
      end
    end

    def width
      MONTH_SECONDS
    end

    def index
      @index ||= MONTHS[@type]
    end

    def to_s
      super << '-monthname-' << @type.to_s
    end
  end
end
