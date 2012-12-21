module Chronic
  class Repeater < Tag

    # Scan an Array of Token objects and apply any necessary Repeater
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_season_names(token) then token.tag(t); next end
        if t = scan_for_month_names(token) then token.tag(t); next end
        if t = scan_for_day_names(token) then token.tag(t); next end
        if t = scan_for_day_portions(token) then token.tag(t); next end
        if t = scan_for_times(token) then token.tag(t); next end
        if t = scan_for_units(token) then token.tag(t); next end
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_season_names(token)
      scan_for token, RepeaterSeasonName,
      {
        /^springs?$/ => :spring,
        /^summers?$/ => :summer,
        /^(autumn)|(fall)s?$/ => :autumn,
        /^winters?$/ => :winter
      }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_month_names(token)
      scan_for token, RepeaterMonthName,
      {
        /^jan[:\.]?(uary)?$/ => :january,
        /^feb[:\.]?(ruary)?$/ => :february,
        /^mar[:\.]?(ch)?$/ => :march,
        /^apr[:\.]?(il)?$/ => :april,
        /^may$/ => :may,
        /^jun[:\.]?e?$/ => :june,
        /^jul[:\.]?y?$/ => :july,
        /^aug[:\.]?(ust)?$/ => :august,
        /^sep[:\.]?(t[:\.]?|tember)?$/ => :september,
        /^oct[:\.]?(ober)?$/ => :october,
        /^nov[:\.]?(ember)?$/ => :november,
        /^dec[:\.]?(ember)?$/ => :december
      }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_day_names(token)
      scan_for token, RepeaterDayName,
      {
        /^m[ou]n(day)?$/ => :monday,
        /^t(ue|eu|oo|u|)s?(day)?$/ => :tuesday,
        /^we(d|dnes|nds|nns)(day)?$/ => :wednesday,
        /^th(u|ur|urs|ers)(day)?$/ => :thursday,
        /^fr[iy](day)?$/ => :friday,
        /^sat(t?[ue]rday)?$/ => :saturday,
        /^su[nm](day)?$/ => :sunday
      }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
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

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
    def self.scan_for_times(token)
      scan_for token, RepeaterTime, /^\d{1,2}(:?\d{1,2})?([\.:]?\d{1,2})?$/
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Repeater object.
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
	      /^hrs?$/ => :hour,
        /^hours?$/ => :hour,
	      /^mins?$/ => :minute,
        /^minutes?$/ => :minute,
	      /^secs?$/ => :second,
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
      raise("Repeater#width must be overridden in subclasses")
    end

    # returns the next occurance of this repeatable.
    def next(pointer)
      raise("Start point must be set before calling #next") unless @now
    end

    def this(pointer)
      raise("Start point must be set before calling #this") unless @now
    end

    def to_s
      'repeater'
    end
  end
end
