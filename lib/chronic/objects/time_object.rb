require 'chronic/handlers/time'

module Chronic
  class TimeObject < HandlerObject
    include TimeStructure
    attr_reader :time_special
    attr_reader :day_portion
    attr_reader :ambiguous
    def initialize(tokens, token_index, definitions, local_date, options)
      super
      @ambiguous = true
      @ambiguous = false if @options[:hours24] == true or @options[:ambiguous_time_range] == :none
      @normalized = false
      match(tokens, @index, definitions)
    end

    def normalize!
      return if @normalized
      if @hour
        if @day_portion == :am       # 0am to 12pm
          @hour = 0 if @hour == 12
          @ambiguous = false
        elsif @time_special == :morning
          @ambiguous = false
        elsif @day_portion == :pm or # 12pm to 0am
              @time_special == :afternoon or
              @time_special == :evening
          @hour += 12 if @hour < 12
          @ambiguous = false
        elsif @time_special == :night
          @hour = 0 if @hour == 12
          @hour += 12 if @hour < 12
          @ambiguous = false
        end
        @hour += 12 if @ambiguous and @hour != 12 and @hour <= @options[:ambiguous_time_range]
      elsif @time_special
        if @time_special == :now
          set_time
        else
          @hour = Time::SPECIAL[@time_special].begin
        end
      else
        @hour = @local_date.hour
      end
      @ambiguous = false
      @minute ||= @second ? @local_date.minute : 0
      @second ||= 0
      @second += @subsecond if @subsecond
      @subsecond = 0
      @normalized = true
    end

    def is_valid?
      normalize!
      true
    end

    def get_end
      hour = @hour
      minute = @minute
      second = @second
      case @precision
      when :hour
        hour += 1
      when :minute
        hour, minute = Time::add_minute(hour, minute)
      when :second
        minute, second = Time::add_second(minute, second)
      when :subsecond
        minute, second = Time::add_second(minute, second, 1.0 / @subsecond_size)
      when :time_special
        if @time_special != :now
          hour = Time::SPECIAL[@time_special].end
          minute = second = 0
        end
      else
        # BUG! Should never happen
        raise "Uknown precision #{@precision.inspect}"
      end
      [hour, minute, second]
    end

    def to_s
      "hour #{@hour.inspect}, minute #{@minute.inspect}, second #{@second.inspect}, subsecond #{@subsecond.inspect}, time special #{time_special.inspect}, day portion #{@day_portion.inspect}, precision #{@precision.inspect}, ambiguous #{ambiguous.inspect}"
    end

    protected

    def set_time
      @hour, @minute, @second = local_time
    end

    include TimeHandlers

  end
end