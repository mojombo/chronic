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
      t = time.gsub(/\:/, '')

      @type =
      case t.size
      when 1..2
        hours = t.to_i
        Tick.new((hours == 12 ? 0 : hours) * 60 * 60, true)
      when 3
        hours = t[0..0].to_i
        ambiguous = hours > 0
        Tick.new((hours * 60 * 60) + (t[1..2].to_i * 60), ambiguous)
      when 4
        ambiguous = time =~ /:/ && t[0..0].to_i != 0 && t[0..1].to_i <= 12
        hours = t[0..1].to_i
        hours == 12 ? Tick.new(0 * 60 * 60 + t[2..3].to_i * 60, ambiguous) : Tick.new(hours * 60 * 60 + t[2..3].to_i * 60, ambiguous)
      when 5
        Tick.new(t[0..0].to_i * 60 * 60 + t[1..2].to_i * 60 + t[3..4].to_i, true)
      when 6
        ambiguous = time =~ /:/ && t[0..0].to_i != 0 && t[0..1].to_i <= 12
        hours = t[0..1].to_i
        hours == 12 ? Tick.new(0 * 60 * 60 + t[2..3].to_i * 60 + t[4..5].to_i, ambiguous) : Tick.new(hours * 60 * 60 + t[2..3].to_i * 60 + t[4..5].to_i, ambiguous)
      else
        raise("Time cannot exceed six digits")
      end
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