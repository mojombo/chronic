require 'chronic/objects/handler_object'
require 'chronic/objects/anchor_object'
require 'chronic/objects/arrow_object'
require 'chronic/objects/narrow_object'
require 'chronic/objects/date_object'
require 'chronic/objects/date_time_object'
require 'chronic/objects/time_object'
require 'chronic/objects/time_zone_object'

module Chronic
  class TokenGroup

    attr_reader :arrows
    attr_reader :narrows
    attr_reader :dates
    attr_reader :times
    attr_reader :timezones
    def initialize(tokens, definitions, local_date, options)
      @anchors = []
      @arrows = []
      @narrows = []
      @datetime = []
      @dates = []
      @times = []
      @timezones = []
      @local_date = local_date
      @options = options

      date_definitions = definitions[:date] + definitions[:endian] + definitions[:short_date]

      tokens.each_index do |i|

        if @anchors.last.nil? or i > @anchors.last.end
          anchor = AnchorObject.new(tokens, i, definitions[:anchor], local_date, options)
          @anchors << anchor if anchor.width > 0
        end
        @anchors.sort_by! { |a| a.width }.reverse!

        if @arrows.last.nil? or i > @arrows.last.end
          arrow = ArrowObject.new(tokens, i, definitions[:arrow], local_date, options)
          @arrows << arrow if arrow.width > 0
        end

        if @narrows.last.nil? or i > @narrows.last.end
          narrow = NarrowObject.new(tokens, i, definitions[:narrow], local_date, options)
          @narrows << narrow if narrow.width > 0
        end

        if @datetime.last.nil? or i > @datetime.last.end
          date = DateTimeObject.new(tokens, i, definitions[:date_time], local_date, options)
          @datetime << date if date.width > 0
        end

        if @dates.last.nil? or i > @dates.last.end
          date = DateObject.new(tokens, i, date_definitions, local_date, options)
          @dates << date if date.width > 0
        end

        if @times.last.nil? or i > @times.last.end or not tokens[@times.last.begin].get_tag(ScalarWide).nil?
          time = TimeObject.new(tokens, i, definitions[:time], local_date, options)
          @times << time if time.width > 0
        end
        @times.sort_by! { |a| a.width }.reverse!

        if @timezones.last.nil? or i > @timezones.last.end
          timezone = TimeZoneObject.new(tokens, i, definitions[:timezone], local_date, options)
          @timezones << timezone if timezone.width > 0
        end

      end
    end

    def get_anchor
      @anchors.find do |anchor|
        anchor.is_valid?
      end
    end

    def get_arrow(anchor = nil)
      arrows = @arrows.select do |arrow|
        (anchor.nil? or (not arrow.overlap?(anchor.range) or arrow.width > anchor.width)) and
        arrow.is_valid?
      end
      Arrow.new(arrows, @options) unless arrows.empty?
    end

    def get_narrow(anchor = nil, arrow = nil)
      @narrows.find do |narrow|
        (anchor.nil? or (not narrow.overlap?(anchor.range) or narrow.width >= anchor.width)) and
        (arrow.nil?  or  not narrow.overlap?(arrow.range)  or narrow.width >= arrow.width) and
        narrow.is_valid?
      end
    end

    def get_datetime(anchor = nil, arrow = nil, narrow = nil)
      @datetime.find do |datetime|
        (anchor.nil? or not datetime.overlap?(anchor.range)) and
        (arrow.nil?  or not datetime.overlap?(arrow.range))  and
        (narrow.nil? or not datetime.overlap?(narrow.range)) and
        datetime.is_valid?
      end
    end

    def get_date(anchor = nil, arrow = nil, narrow = nil, datetime = nil)
      @dates.find do |date|
        (anchor.nil?   or  not date.overlap?(anchor.range))   and
        (arrow.nil?    or (not date.overlap?(arrow.range)      or date.width > arrow.width or narrow)) and
        (narrow.nil?   or  not date.overlap?(narrow.range))   and
        (datetime.nil? or  not date.overlap?(datetime.range)) and
        date.is_valid?
      end
    end

    def get_next_date(anchor = nil, arrow, narrow, datetime, date, time, timezone)
      @dates.find do |nextdate|
        not nextdate.overlap?(date.range) and
        (anchor.nil?   or not nextdate.overlap?(anchor.range))   and
        (arrow.nil?    or not nextdate.overlap?(arrow.range))    and
        (narrow.nil?   or not nextdate.overlap?(narrow.range))   and
        (datetime.nil? or not nextdate.overlap?(datetime.range)) and
        (time.nil?     or not nextdate.overlap?(time.range))     and
        (timezone.nil? or not nextdate.overlap?(timezone.range)) and
        nextdate.is_valid? and not nextdate.year.nil?
      end
    end

    def get_time(anchor = nil, arrow = nil, narrow = nil, datetime = nil, date = nil)
      @times.find do |time|
        (anchor.nil?   or (not time.overlap?(anchor.range)     or time.width >  anchor.width)) and
        (arrow.nil?    or (not time.overlap?(arrow.range)      or time.end   >= arrow.end)) and
        (narrow.nil?   or  not time.overlap?(narrow.range))   and
        (datetime.nil? or  not time.overlap?(datetime.range)) and
        (date.nil?     or (not time.overlap?(date.range)       or time.width >= date.width )) and
        time.is_valid?
      end
    end

    def get_timezone(anchor = nil, arrow = nil, narrow = nil, datetime = nil, date = nil, time = nil)
      @timezones.find do |timezone|
        (anchor.nil?   or not timezone.overlap?(anchor.range))   and
        (arrow.nil?    or not timezone.overlap?(arrow.range))    and
        (narrow.nil?   or not timezone.overlap?(narrow.range))   and
        (datetime.nil? or not timezone.overlap?(datetime.range)) and
        (date.nil?     or not timezone.overlap?(date.range))     and
        (time.nil?     or not timezone.overlap?(time.range))     and
        timezone.is_valid?
      end
    end

    def update_date(anchor, arrow, narrow, datetime, date, time, timezone)
      return if not date or date.year.nil?
      next_date = get_next_date(anchor, arrow, narrow, datetime, date, time, timezone)
      date.year = next_date.year if next_date
    end

    def refresh(anchor, arrow, narrow, datetime, date, time, timezone)
      anchor = nil if anchor and (
                                   (arrow    and anchor.overlap?(arrow.range)) or
                                   (datetime and anchor.overlap?(datetime.range)) or
                                   (date     and anchor.overlap?(date.range)) or
                                   (time     and anchor.overlap?(time.range)) or
                                   (timezone and anchor.overlap?(timezone.range))
                                 )
      arrow = nil if arrow and (
                                   (narrow   and arrow.overlap?(narrow.range)) or
                                   (datetime and arrow.overlap?(datetime.range)) or
                                   (date     and arrow.overlap?(date.range)) or
                                   (time     and arrow.overlap?(time.range)) or
                                   (timezone and arrow.overlap?(timezone.range))
                                 )
      narrow = nil if narrow and (
                                   (datetime and narrow.overlap?(datetime.range)) or
                                   (date     and narrow.overlap?(date.range)) or
                                   (time     and narrow.overlap?(time.range)) or
                                   (timezone and narrow.overlap?(timezone.range))
                                 )

      if anchor and narrow and anchor.overlap?(narrow.range)
       if date or narrow.width > anchor.width
         anchor = nil
       else
         narrow = nil
       end
      end

      if date and time and date.overlap?(time.range)
       if time.width > date.width or anchor
         date = nil
       else
         time = nil
       end
      end
      [anchor, arrow, narrow, datetime, date, time, timezone]
    end

    def get_all
      anchor = get_anchor
      arrow = get_arrow(anchor)
      narrow = get_narrow(anchor, arrow)
      datetime = get_datetime(anchor, arrow, narrow)
      date = get_date(anchor, arrow, narrow, datetime)
      time = get_time(anchor, arrow, narrow, datetime, date)
      timezone = get_timezone(anchor, arrow, narrow, datetime, date, time)
      update_date(anchor, arrow, narrow, datetime, date, time, timezone)
      refresh(anchor, arrow, narrow, datetime, date, time, timezone)
    end

    def get_sign
      (@options[:context] == :past) ? -1 : ((@options[:context] == :future) ? 1 : 0)
    end

    def to_span
      span = nil
      objects = get_all
      anchor, arrow, narrow, datetime, date, time, timezone = objects
      if datetime
        puts "\nUse " + datetime.class.to_s if Chronic.debug
        span = datetime.to_span
      elsif anchor or arrow or narrow or datetime or date or time
        puts "\nUse " + objects.reject(&:nil?).sort_by { |o| o.begin }.map(&:class).join(' + ') if Chronic.debug

        if arrow
          time = TimeInfo.new(@local_date) if not time
          arrow_date = date
          arrow_date = DateInfo.new(@local_date) unless arrow_date
          span = arrow_date.to_span(time, timezone)
          span = arrow.to_span(span, timezone)
        end

        if anchor
          time = TimeInfo.new(@local_date) if not time
          span = anchor.to_span(span, time, timezone)
          if date
            sbegin = span.begin
            date.local_date = sbegin
            date.force_normalize!
            span = date.to_span(nil, timezone)
            sign = get_sign
            if not sign.zero? and date.wday.nil? and (span.begin - @local_date) * sign < 0
              year, month, day = Date::split(sbegin)
              date.local_date = ::Time::mktime(year + sign, month, day)
              date.force_normalize!
              span = date.to_span(nil, timezone)
            end
          end
        end

        if not arrow and not anchor and time
          sign = get_sign
          time_compare = sign.zero? ? false : ((sign == -1) ? (time > @local_date) : (time < @local_date))
          date = DateInfo.new(@local_date) unless date
          date.add_day(sign) if not date.is_a?(DateObject) and date.is_equal?(@local_date) and time_compare
          span = time.to_span(date, timezone)
        end

        span = date.to_span(nil, timezone) if span.nil? and date

        span = narrow.to_span(span, timezone) if narrow

      end

      if Chronic.debug
        puts "\n-- Span" + span.to_s if span
        puts '-none' unless span
      end

      span
    end

  end
end
