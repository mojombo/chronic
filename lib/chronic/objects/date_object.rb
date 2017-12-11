require 'chronic/handlers/date'

module Chronic
  class DateObject < HandlerObject
    include DateStructure
    attr_reader :wday
    attr_reader :day_special
    def initialize(tokens, token_index, definitions, local_date, options)
      super
      handle_possible(KeywordOn)
      unless handle_possible(KeywordIn)
        handle_possible(SeparatorSpace)
      end
      @normalized = false
      match(tokens, @index, definitions)
    end

    def normalize!
      return if @normalized
      adjust!
      @normalized = true
    end

    def force_normalize!
      @year = @local_date.year unless @have_year
      @month = @local_date.month unless @have_month
      @day = @local_date.day unless @have_day
      adjust!
      @normalized = true
    end

    def is_valid?
      normalize!
      return false if @year.nil? or @month.nil? or @day.nil?
      ::Date.valid_date?(@year, @month, @day)
    end

    def get_end
      year = @year
      month = @month
      day = @day
      case @precision
      when :year
        year += 1
        month = 1
        day = 1
      when :month
        year, month = Date::add_month(year, month)
        day = 1
      when :day
        year, month, day = Date::add_day(year, month, day)
      else
        # BUG! Should never happen
        raise "Uknown precision #{@precision}"
      end
      [year, month, day]
    end

    def to_s
      "year #{@year.inspect}, month #{@month.inspect}, day #{@day.inspect}, wday #{@wday.inspect}, day special #{@day_special.inspect}, precision #{@precision.inspect}"
    end

    protected

    def get_date_compare(sign)
      sign.zero? ? false : ((sign == -1) ? (@day > @local_date.day) : (@day < @local_date.day))
    end

    def adjust!
      sign = get_sign
      if @day_special
        set_date
        case @day_special
        when :yesterday
          @year, @month, @day = Date::add_day(@year, @month, @day, -1)
        when :today
          # do nothing
        when :tomorrow
          @year, @month, @day = Date::add_day(@year, @month, @day, 1)
        else
          raise "Uknown special day #{@day_special.inspect}"
        end
        @precision = :day
      elsif @wday
        year, month, day = local_day
        year = @year if @year
        month = @month if @month
        day = @day if @day
        date = ::Date.new(year, month, day)
        s = 0
        s = sign if not @have_year and not @have_month and not @have_day
        diff = Date::wday_diff(date, @wday, s, 0)
        actual_year, actual_month, actual_day = Date::add_day(year, month, day, diff)
        if @have_day and @day != actual_day
          actual_day = @day
          n = 0
          s = sign
          if not @month
            begin
              n += s
              actual_year, actual_month = Date::add_month(year, month, n)
              date = ::Date.new(actual_year, actual_month, actual_day)
              actual_year = nil if date.wday != @wday or (@year and @year != actual_year)
            end while actual_year.nil? and n*s < 20
          elsif not @year
            actual_month = @month
            begin
              actual_year = year + n*s
              date = ::Date.new(actual_year, actual_month, actual_day)
              actual_year = nil if date.wday != @wday
              n += 1 if s == sign
              s *= -1
            end while actual_year.nil? and n < 200
          else
            actual_year = nil
          end
        elsif @have_month and @month != actual_month
          if not @year
            n = 0
            begin
              n += 1
              year += sign
              date = ::Date.new(year, month, day)
              diff = Date::wday_diff(date, @wday, sign)
              actual_year, actual_month, actual_day = Date::add_day(year, month, day, diff)
              actual_year = nil if @month != actual_month
            end while actual_year.nil? and n < 50
          else
            actual_year = nil
          end
        elsif @have_year and @year != actual_year
          actual_year = nil
        end
        @year, @month, @day = [actual_year, actual_month, actual_day]
        @precision = :day
      else
        @month = 1 if not @month and not @day
        @day ||= 1
        date_compare = get_date_compare(sign)
        if @year.nil?
          @year = @local_date.year
          if @month.nil?
            @month = @local_date.month
            @year, @month = Date::add_month(@year, @month, sign) if date_compare
          elsif not sign.zero?
            month_compare = (sign == -1) ? (@month > @local_date.month) : (@month < @local_date.month)
            @year += sign if month_compare or (@month == @local_date.month and date_compare)
          end
        elsif @month.nil? and date_compare
          @year, @month = Date::add_month(@year, @local_date.month, sign)
        elsif @month.nil?
          @month = @local_date.month
        end
      end
    end

    def set_date
      @year, @month, @day = local_day
    end

    include DateHandlers

  end
end
