module Chronic
  class Arrow
    BASE_UNITS = [
      :years,
      :months,
      :days,
      :hours,
      :minutes,
      :seconds
    ]

    UNITS = BASE_UNITS + [
      :miliseconds,
      :mornings,
      :noons,
      :afternoons,
      :evenings,
      :nights,
      :midnights,
      :weeks,
      :weekdays,
      :wdays,
      :weekends,
      :fortnights,
      :quarters,
      :seasons
    ]

    PRECISION = [
      :miliseconds,
      :seconds,
      :minutes,
      :noons,
      :midnights,
      :hours,
      :mornings,
      :afternoons,
      :evenings,
      :nights,
      :days,
      :weekdays,
      :weekends,
      :wdays,
      :weeks,
      :fortnights,
      :months,
      :quarters,
      :seasons,
      :years
    ]

    attr_reader :begin
    attr_reader :end

    UNITS.each { |u| attr_reader u }

    attr_reader :pointer
    attr_reader :order

    def initialize(arrows, options)
      @options = options
      @ordered = []
      build(arrows)
    end

    def range
      @begin..@end
    end

    def width
      @end - @begin
    end

    def overlap?(r2)
      r1 = range
      (r1.begin <= r2.end) and (r2.begin <= r1.end)
    end

    def translate_unit(unit)
      unit.to_s + 's'
    end

    def to_span(span, timezone = nil)
      precision = PRECISION.length - 1
      ds = Date::split(span.begin)
      ds += Time::split(span.begin)
      case span.precision
      when :year
        precision = PRECISION.index(:years)
        ds[3] = ds[4] = ds[5] = 0
      when :month
        precision = PRECISION.index(:months)
        ds[3] = ds[4] = ds[5] = 0
      when :day, :day_special
        precision = PRECISION.index(:days)
        ds[3] = ds[4] = ds[5] = 0
      when :hour
        precision = PRECISION.index(:hours)
      when :minute
        precision = PRECISION.index(:minutes)
      when :second
        precision = PRECISION.index(:seconds)
      when :time_special
        precision = 0
      end

      sign = (@pointer == :past) ? -1 : 1
      @ordered.each do |data|
        unit = data.first
        count = data[1]
        special = data.last
        case unit
        when *BASE_UNITS
          ds[BASE_UNITS.index(unit)] += sign * count
          ds[2], ds[3], ds[4], ds[5] = Time::normalize(ds[2], ds[3], ds[4], ds[5])
          ds[0], ds[1], ds[2] = Date::normalize(ds[0], ds[1], ds[2])
          precision = update_precision(precision, unit)
        when :seasons
          # TODO
          raise "Not Implemented Arrow #{unit}"
        when :quarters
          ds[0], quarter = Date::add_quarter(ds[0], Date::get_quarter_index(ds[1]), sign * count)
          ds[1] = Date::QUARTERS[quarter]
          ds[2] = 1
          ds[3], ds[4], ds[5] = 0, 0, 0
          precision = PRECISION.index(unit)
        when :fortnights
          ds[0], ds[1], ds[2] = Date::add_day(ds[0], ds[1], ds[2], sign * count * Date::FORTNIGHT_DAYS)
          precision = update_precision(precision, unit)
        when :weeks
          ds[0], ds[1], ds[2] = Date::add_day(ds[0], ds[1], ds[2], sign * count * Date::WEEK_DAYS)
          precision = update_precision(precision, unit)
        when :wdays
          date = Chronic.time_class.new(ds[0], ds[1], ds[2])
          diff = Date::wday_diff(date, special, sign)
          ds[0], ds[1], ds[2] = Date::add_day(ds[0], ds[1], ds[2], diff + sign * (count - 1) * Date::WEEK_DAYS)
          precision = update_precision(precision, unit)
        when :weekends
          date = Chronic.time_class.new(ds[0], ds[1], ds[2])
          diff = Date::wday_diff(date, Date::DAYS[:saturday], sign)
          ds[0], ds[1], ds[2] = Date::add_day(ds[0], ds[1], ds[2], diff + sign * (count - 1) * Date::WEEK_DAYS)
          ds[3], ds[4], ds[5] = 0, 0, 0
          precision = update_precision(precision, unit)
        when :weekdays
          # TODO
          raise "Not Implemented Arrow #{unit}"
        when :days
          # TODO
          raise "Not Implemented Arrow #{unit}"
        when :mornings, :noons, :afternoons, :evenings, :nights, :midnights
          name = n(unit)
          count -= 1 if @pointer == :past and ds[3] > Time::SPECIAL[name].end
          count += 1 if @pointer == :future and ds[3] < Time::SPECIAL[name].begin
          ds[0], ds[1], ds[2] = Date::add_day(ds[0], ds[1], ds[2], sign * count)
          ds[3], ds[4], ds[5] = Time::SPECIAL[name].begin, 0, 0
          precision = PRECISION.index(unit)
        when :miliseconds
          # TODO
          raise "Not Implemented Arrow #{unit}"
        end
      end

      de = ds.dup
      case PRECISION[precision]
      when :miliseconds
        de[4], de[5] = Time::add_second(ds[4], ds[5], 0.001)
      when :seconds
        de[4], de[5] = Time::add_second(ds[4], ds[5])
      when :minutes
        de[3], de[4] = Time::add_minute(ds[3], ds[4])
        de[5] = 0
      when :mornings, :noons, :afternoons, :evenings, :nights, :midnights
        name = n(PRECISION[precision])
        de[3], de[4], de[5] = Time::SPECIAL[name].end, 0, 0
      when :hours
        de[2], de[3] = Time::add_hour(ds[2], ds[3])
        de[4] = de[5] = 0
      when :days, :weekdays, :wdays
        de[0], de[1], de[2] = Date::add_day(ds[0], ds[1], ds[2])
        de[3] = de[4] = de[5] = 0
      when :weekends
        end_date = Chronic.time_class.new(ds[0], ds[1], ds[2])
        diff = Date::wday_diff(end_date, Date::DAYS[:monday])
        de[0], de[1], de[2] = Date::add_day(ds[0], ds[1], ds[2], diff)
        de[3] = de[4] = de[5] = 0
      when :weeks
        end_date = Chronic.time_class.new(ds[0], ds[1], ds[2])
        diff = Date::wday_diff(end_date, Date::DAYS[@options[:week_start]])
        de[0], de[1], de[2] = Date::add_day(ds[0], ds[1], ds[2], diff)
        de[3] = de[4] = de[5] = 0
      when :fortnights
        end_date = Chronic.time_class.new(ds[0], ds[1], ds[2])
        diff = Date::wday_diff(end_date, Date::DAYS[@options[:week_start]])
        de[0], de[1], de[2] = Date::add_day(ds[0], ds[1], ds[2], diff + Date::WEEK_DAYS)
        de[3] = de[4] = de[5] = 0
      when :months
        de[0], de[1] = Date::add_month(ds[0], ds[1])
        de[2] = 1
        de[3] = de[4] = de[5] = 0
      when :quarters
        de[0], quarter = Date::add_quarter(ds[0], Date::get_quarter_index(ds[1]))
        de[1] = Date::QUARTERS[quarter]
        de[2] = 1
        de[3] = de[4] = de[5] = 0
      when :seasons
        # TODO
        raise "Not Implemented Arrow #{PRECISION[precision]}"
      when :years
        de[0] += 1
        de[1] = de[2] = 1
        de[3] = de[4] = de[5] = 0
      end
      utc_offset = nil
      end_utc_offset = nil
      if timezone
        utc_offset = timezone.to_offset(ds[0], ds[1], ds[2], ds[3], ds[4], ds[5])
        end_utc_offset = timezone.to_offset(de[0], de[1], de[2], de[3], de[4], de[5])
      end
      span_start = Chronic.construct(ds[0], ds[1], ds[2], ds[3], ds[4], ds[5], utc_offset)
      span_end   = Chronic.construct(de[0], de[1], de[2], de[3], de[4], de[5], utc_offset)
      Span.new(span_start, span_end)
    end

    def to_s
      full = []
      UNITS.each do |unit|
        count = instance_variable_get('@'+unit.to_s)
        full << [unit, count].join(' ') unless count.nil?
      end
      unless full.empty?
        'Arrow => ' + @pointer.inspect + ' ' + full.join(', ')
      else
        'Arrow => empty'
      end
    end

    protected

    def n(unit)
      s = unit.to_s
      s.to_s[0, s.length - 1].to_sym
    end

    def v(v)
      '@'+v.to_s
    end

    def update_precision(precision, unit)
      new_precision = PRECISION.index(unit)
      precision = new_precision if new_precision < precision
      precision
    end

    def build(arrows)
      arrows.each do |arrow|
        @begin = arrow.begin if @begin.nil? or @begin > arrow.begin
        @end = arrow.end if @end.nil? or @end < arrow.end
        @pointer = arrow.pointer if @pointer.nil? and not arrow.pointer.nil?
        next if arrow.unit.nil?
        unit = translate_unit(arrow.unit)
        raise "Uknown unit #{unit.to_sym.inspect}" unless UNITS.include?(unit.to_sym)
        count = instance_variable_get(v(unit))
        count ||= 0
        @ordered << [unit.to_sym, arrow.count, arrow.special]
        instance_variable_set(v(unit), count+arrow.count)
      end
    end

  end
end