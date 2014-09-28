module Chronic
  class Unit < Tag

    # Scan an Array of Token objects and apply any necessary Unit
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        token.tag scan_for_units(token, options)
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new Unit object.
    def self.scan_for_units(token, options = {})
      patterns.each do |item, symbol|
        if item =~ token.word
          klass_name = 'Unit' + symbol.to_s.capitalize
          klass = Chronic.const_get(klass_name)
          return klass.new(symbol, options)
        end
      end
      return nil
    end

    def self.patterns
      @@paterns ||= {
        /^years?$/i               => :year,
        /^seasons?$/i             => :season,
        /^months?$/i              => :month,
        /^fortnights?$/i          => :fortnight,
        /^weeks?$/i               => :week,
        /^weekends?$/i            => :weekend,
        /^(week|business)days?$/i => :weekday,
        /^days?$/i                => :day,
        /^mornings?$/i            => :morning,
        /^noons?$/                => :noon,
        /^afternoons?$/i          => :afternoon,
        /^evenings?$/i            => :evening,
        /^(to)?(night|nite)s?$/i  => :night,
        /^midnights?$/i           => :midnight,
        /^(hr|hour)s?$/i          => :hour,
        /^(min|minute)s?$/i       => :minute,
        /^(sec|second)s?$/i       => :second,
        /^(ms|miliseconds?)$/i    => :milisecond
      }
    end

    def to_s
      'unit'
    end
  end

  class UnitYear < Unit #:nodoc:
    def to_s
      super << '-year'
    end
  end

  class UnitSeason < Unit #:nodoc:
    def to_s
      super << '-season'
    end
  end

  class UnitQuarter < Unit #:nodoc:
    def to_s
      super << '-quarter'
    end
  end

  class UnitMonth < Unit #:nodoc:
    def to_s
      super << '-month'
    end
  end

  class UnitFortnight < Unit #:nodoc:
    def to_s
      super << '-fortnight'
    end
  end

  class UnitWeek < Unit #:nodoc:
    def to_s
      super << '-week'
    end
  end

  class UnitWeekend < Unit #:nodoc:
    def to_s
      super << '-weekend'
    end
  end

  class UnitWeekday < Unit #:nodoc:
    def to_s
      super << '-weekday'
    end
  end

  class UnitDay < Unit #:nodoc:
    def to_s
      super << '-day'
    end
  end

  class UnitMorning < Unit #:nodoc:
    def to_s
      super << '-morning'
    end
  end

  class UnitNoon < Unit #:nodoc:
    def to_s
      super << '-noon'
    end
  end

  class UnitAfternoon < Unit #:nodoc:
    def to_s
      super << '-afternoon'
    end
  end

  class UnitEvening < Unit #:nodoc:
    def to_s
      super << '-evening'
    end
  end

  class UnitNight < Unit #:nodoc:
    def to_s
      super << '-night'
    end
  end

  class UnitMidnight < Unit #:nodoc:
    def to_s
      super << '-night'
    end
  end

  class UnitHour < Unit #:nodoc:
    def to_s
      super << '-hour'
    end
  end

  class UnitMinute < Unit #:nodoc:
    def to_s
      super << '-minute'
    end
  end

  class UnitSecond < Unit #:nodoc:
    def to_s
      super << '-second'
    end
  end

  class UnitMilisecond < Unit #:nodoc:
    def to_s
      super << '-milisecond'
    end
  end

end
