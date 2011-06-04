module Chronic
  class Repeater < Tag #:nodoc:
    def self.scan(tokens, options)
      # for each token
      tokens.each_index do |i|
        if t = scan_for_season_names(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_month_names(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_day_names(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_day_portions(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_times(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_units(tokens[i]) then tokens[i].tag(t); next end
      end
    end

    def self.scan_for_season_names(token)
      scan_for token, RepeaterSeasonName,
      {
        /^springs?$/ => :spring,
        /^summers?$/ => :summer,
        /^(autumn)|(fall)s?$/ => :autumn,
        /^winters?$/ => :winter
      }
    end

    def self.scan_for_month_names(token)
      scan_for token, RepeaterMonthName,
      {
        /^jan\.?(uary)?$/ => :january,
        /^feb\.?(ruary)?$/ => :february,
        /^mar\.?(ch)?$/ => :march,
        /^apr\.?(il)?$/ => :april,
        /^may$/ => :may,
        /^jun\.?e?$/ => :june,
        /^jul\.?y?$/ => :july,
        /^aug\.?(ust)?$/ => :august,
        /^sep\.?(t\.?|tember)?$/ => :september,
        /^oct\.?(ober)?$/ => :october,
        /^nov\.?(ember)?$/ => :november,
        /^dec\.?(ember)?$/ => :december
      }
    end

    def self.scan_for_day_names(token)
      scan_for token, RepeaterDayName,
      {
        /^m[ou]n(day)?$/ => :monday,
        /^t(ue|eu|oo|u|)s(day)?$/ => :tuesday,
        /^tue$/ => :tuesday,
        /^we(dnes|nds|nns)day$/ => :wednesday,
        /^wed$/ => :wednesday,
        /^th(urs|ers)day$/ => :thursday,
        /^thu(rs)?$/ => :thursday,
        /^fr[iy](day)?$/ => :friday,
        /^sat(t?[ue]rday)?$/ => :saturday,
        /^su[nm](day)?$/ => :sunday
      }
    end

    def self.scan_for_day_portions(token)
      scan_for token, RepeaterDayPortion,
      {
        /^ams?$/ => :am,
        /^pms?$/ => :pm,
        /^mornings?$/ => :morning,
        /^afternoons?$/ => :afternoon,
        /^evenings?$/ => :evening,
        /^(night|nite)s?$/ => :night
      }
    end

    def self.scan_for_times(token)
      if token.word =~ /^\d{1,2}(:?\d{2})?([\.:]?\d{2})?$/
        return Chronic::RepeaterTime.new(token.word)
      end
      return nil
    end

    def self.scan_for_units(token)
      {
        /^years?$/ => :year,
        /^seasons?$/ => :season,
        /^months?$/ => :month,
        /^fortnights?$/ => :fortnight,
        /^weeks?$/ => :week,
        /^weekends?$/ => :weekend,
        /^(week|business)days?$/ => :weekday,
        /^days?$/ => :day,
        /^hours?$/ => :hour,
        /^minutes?$/ => :minute,
        /^seconds?$/ => :second
      }.each do |item, symbol|
        if item =~ token.word
          klass_name = 'Repeater' + symbol.to_s.capitalize
          klass = Chronic.const_get(klass_name)
          return klass.new(symbol)
        end
      end
      return nil
    end

    def <=>(other)
      width <=> other.width
    end

    # returns the width (in seconds or months) of this repeatable.
    def width
      raise("Repeatable#width must be overridden in subclasses")
    end

    # returns the next occurance of this repeatable.
    def next(pointer)
      !@now.nil? || raise("Start point must be set before calling #next")
    end

    def this(pointer)
      !@now.nil? || raise("Start point must be set before calling #this")
    end

    def to_s
      'repeater'
    end
  end
end