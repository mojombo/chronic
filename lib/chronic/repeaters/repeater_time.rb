module Chronic
  class RepeaterTime < Repeater #:nodoc:
    class Tick #:nodoc:
      attr_accessor :time

      def initialize(time, ambiguous = false)
        @time = time
        @ambiguous = ambiguous
      end

      def ambiguous?
        @ambiguous
      end

      def *(other)
        Tick.new(@time * other, @ambiguous)
      end

      def to_f
        @time.to_f
      end

      def to_s
        @time.to_s + (@ambiguous ? '?' : '')
      end

    end

    def initialize(time)
      @current_time = nil
      timeParts = time.split(':')
      raise("Time cannot have more than 4 groups of ':'") if timeParts.count > 4

      if timeParts.first.length > 2 and timeParts.count == 1
        if timeParts.first.length > 4
          secondIndex = timeParts.first.length - 2
          timeParts.insert(1, timeParts.first[secondIndex..timeParts.first.length])
          timeParts[0] = timeParts.first[0..secondIndex - 1]
        end
        minuteIndex = timeParts.first.length - 2
        timeParts.insert(1, timeParts.first[minuteIndex..timeParts.first.length])
        timeParts[0] = timeParts.first[0..minuteIndex - 1]
      end

      ambiguous = false
      hours = timeParts.first.to_i
      ambiguous = true if (timeParts.first.length == 1 and hours > 0) or (hours >= 10 and hours <= 12)
      hours = (hours == 12 ? 0 : hours) * 60 * 60
      minutes = 0
      seconds = 0
      subseconds = 0

      minutes = timeParts[1].to_i * 60 if timeParts.count > 1
      seconds = timeParts[2].to_i if timeParts.count > 2
      subseconds = timeParts[3].to_f / (10 ** timeParts[3].length) if timeParts.count > 3

      @type = Tick.new(hours + minutes + seconds + subseconds, ambiguous)
    end

    # Return the next past or future Span for the time that this Repeater represents
    #   pointer - Symbol representing which temporal direction to fetch the next day
    #             must be either :past or :future
    def next(pointer)
      super

      half_day = 60 * 60 * 12
      full_day = 60 * 60 * 24

      first = false

      unless @current_time
        first = true
        midnight = Chronic.time_class.local(@now.year, @now.month, @now.day)

        yesterday_midnight = midnight - full_day
        tomorrow_midnight = midnight + full_day

        offset_fix = midnight.gmt_offset - tomorrow_midnight.gmt_offset
        tomorrow_midnight += offset_fix

        catch :done do
          if pointer == :future
            if @type.ambiguous?
              [midnight + @type.time + offset_fix, midnight + half_day + @type.time + offset_fix, tomorrow_midnight + @type.time].each do |t|
                (@current_time = t; throw :done) if t >= @now
              end
            else
              [midnight + @type.time + offset_fix, tomorrow_midnight + @type.time].each do |t|
                (@current_time = t; throw :done) if t >= @now
              end
            end
          else # pointer == :past
            if @type.ambiguous?
              [midnight + half_day + @type.time + offset_fix, midnight + @type.time + offset_fix, yesterday_midnight + @type.time + half_day].each do |t|
                (@current_time = t; throw :done) if t <= @now
              end
            else
              [midnight + @type.time + offset_fix, yesterday_midnight + @type.time].each do |t|
                (@current_time = t; throw :done) if t <= @now
              end
            end
          end
        end

        @current_time || raise("Current time cannot be nil at this point")
      end

      unless first
        increment = @type.ambiguous? ? half_day : full_day
        @current_time += pointer == :future ? increment : -increment
      end

      Span.new(@current_time, @current_time + width)
    end

    def this(context = :future)
      super

      context = :future if context == :none

      self.next(context)
    end

    def width
      1
    end

    def to_s
      super << '-time-' << @type.to_s
    end
  end
end
