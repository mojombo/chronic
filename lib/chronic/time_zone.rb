module Chronic
  class TimeZone

    # normalize offset in seconds to offset as string +mm:ss or -mm:ss
    def self.normalize_offset(offset = nil)
      return offset if offset.is_a?(String)
      offset = Chronic.time_class.now.to_time.utc_offset unless offset # get current system's UTC offset if offset is nil
      sign = '+'
      sign = '-' if offset < 0
      hours = (offset.abs / Time::HOUR_SECONDS).to_i.to_s.rjust(2,'0')
      minutes = (offset.abs % Time::HOUR_SECONDS).to_s.rjust(2,'0')
      sign + hours + minutes
    end

    def self.abbreviation_offests(abbr, date = nil)
      TimezoneParser::Abbreviation.getOffsets(abbr, date, date).first
    end

    def self.name_offsets(name, date = nil)
      TimezoneParser::Timezone.getOffsets(name, date, date).first
    end

    def self.zone_offsets(zone)
      TZInfo::Timezone.get(@zone).current_period.utc_offset
    end

    def self.is_valid_abbr?(abbr)
      TimezoneParser::Abbreviation.isValid?(abbr)
    end

    def self.is_valid_name?(name)
      TimezoneParser::Timezone.isValid?(name)
    end

    def self.is_valid_zone?(name)
      false # TODO
    end

    def self.to_offset(hour, minute, sign = 1)
      offset = hour * Time::HOUR_SECONDS + minute * Time::MINUTE_SECONDS
      offset *= sign
      offset
    end

  end

  module TimeZoneStructure
    attr_reader :offset
    attr_reader :sign
    attr_reader :tzhour
    attr_reader :tzminute
    attr_reader :name
    attr_reader :abbr
    attr_reader :zone

    def to_offset(year, month = 1, day = 1, hour = 0, minute = 0, second = 0)
      date = DateTime.new(year, month, day, hour, minute, second)
      if @abbr
        TimeZone::abbreviation_offests(@abbr, date)
      elsif @name
        TimeZone::name_offsets(@name, date)
      elsif @zone
        TimeZone::zone_offsets(@zone)
      elsif @tzhour
        sign = 1
        sign = -1 if @sign and @sign.type == :minus
        TimeZone::to_offset(@tzhour, @tzminute, sign)
      else
        @offset
      end
    end

    def to_s
      sign = @sign ? @sign.type.inspect : 'nil'
      "sign #{sign}, tzhour #{@tzhour.inspect}, tzminute #{@tzminute.inspect}, offset #{@offset.inspect}, name #{@name.inspect}, abbr #{@abbr.inspect}, zone #{@zone.inspect}"
    end

  end

end
