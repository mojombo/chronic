class Chronic::Repeater < Chronic::Tag #:nodoc:
  def self.scan(tokens, options)
    # for each token
    tokens.each_index do |i|
      if t = self.scan_for_month_names(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_day_names(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_day_portions(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_times(tokens[i], options) then tokens[i].tag(t); next end
      if t = self.scan_for_units(tokens[i]) then tokens[i].tag(t); next end
    end
    tokens
  end
  
  def self.scan_for_month_names(token)
    scanner = {/^jan\.?(uary)?$/ => :january,
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
               /^dec\.?(ember)?$/ => :december}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterMonthName.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    return nil
  end
  
  def self.scan_for_day_names(token)
    scanner = {/^m[ou]n(day)?$/ => :monday,
               /^t(ue|eu|oo|u|)s(day)?$/ => :tuesday,
               /^tue$/ => :tuesday,
               /^we(dnes|nds|nns)day$/ => :wednesday,
               /^wed$/ => :wednesday,
               /^th(urs|ers)day$/ => :thursday,
               /^thu$/ => :thursday,
               /^fr[iy](day)?$/ => :friday,
               /^sat(t?[ue]rday)?$/ => :saturday,
               /^su[nm](day)?$/ => :sunday}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterDayName.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    return nil
  end
  
  def self.scan_for_day_portions(token)
    scanner = {/^ams?$/ => :am,
               /^pms?$/ => :pm,
               /^mornings?$/ => :morning,
               /^afternoons?$/ => :afternoon,
               /^evenings?$/ => :evening,
               /^(night|nite)s?$/ => :night}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterDayPortion.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    return nil
  end
  
  def self.scan_for_times(token, options)
    if token.word =~ /^\d{1,2}(:?\d{2})?([\.:]?\d{2})?$/
      return Chronic::RepeaterTime.new(token.word, options)
    end
    return nil
  end
  
  def self.scan_for_units(token)
    scanner = {/^years?$/ => :year,
               /^seasons?$/ => :season,
               /^months?$/ => :month,
               /^fortnights?$/ => :fortnight,
               /^weeks?$/ => :week,
               /^weekends?$/ => :weekend,
               /^days?$/ => :day,
               /^hours?$/ => :hour,
               /^minutes?$/ => :minute,
               /^seconds?$/ => :second}
    scanner.keys.each do |scanner_item|
      if scanner_item =~ token.word
        klass_name = 'Chronic::Repeater' + scanner[scanner_item].to_s.capitalize
        klass = eval(klass_name)
        return klass.new(scanner[scanner_item]) 
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
    [:future, :none, :past].include?(pointer) || raise("First argument 'pointer' must be one of :past or :future")
    #raise("Repeatable#next must be overridden in subclasses")
  end
  
  def this(pointer)
    !@now.nil? || raise("Start point must be set before calling #this")
    [:future, :past, :none].include?(pointer) || raise("First argument 'pointer' must be one of :past, :future, :none")
  end
  
  def to_s
    'repeater'
  end
end