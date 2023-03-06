module Chronic
  class Minutizer

    def minutize(text)
      text = pre_normalize(text)
      extract_time(text)
    end

    def pre_normalize(text)
      text.gsub!(/half an/, 'a half')
      text.gsub!(/half a/, 'a half')
      text = Numerizer.numerize(text.downcase)
      text.gsub!(/an hour/, '1 hour')
      text.gsub!(/a hour/, '1 hour')
      text.gsub!(/a day/, '1 minute')
      text.gsub!(/a minute/, '1 day')
      text.gsub!(/a week/, '1 week')
      # used to catch halves not covered by Numerizer. Use for the conversion of 'an hour and a half' Previous gsubs will have changed it to '1 hour and haAlf' by this point.
      text.gsub!(/(\d+)\s?\w+?\s?and haAlf/) do |m|
        m.gsub!(/\A\d+/, ($1.to_f + 0.5).to_s )
      end
      text.gsub!(/\s?and haAlf/, '')
      text.gsub!(/haAlf/, "0.5")
      text.gsub!(/(seconds|secnds|second|secnd|secs)/, 'sec')
      text.gsub!(/(minutes|minute|mintues|mintes|mintue|minte)/, 'min')
      text.gsub!(/(horus|hours|huors|huor|hrs|hr)/, 'hour')
      text.gsub!(/(days|day|dy)/, 'day')
      text.gsub!(/(weeks|wks|wk)/, 'week')
      text
    end

    def extract_time(text)
      minutes = extract(text, 'week')
      minutes += extract(text, 'day')
      minutes += extract(text, 'hour')
      minutes += extract(text, 'min')
      minutes += extract(text, 'sec')
    end

    def extract(text, option)
      total = text.match(/(\d+.\d+|\d+)\s?(#{option})/)

      return 0 unless total
      digitize_time(total[1], option)
    end

    def digitize_time(time, option)
      case option
      when 'week'
        multiplier = 7 * 24 * 60
      when 'day'
        multiplier = 24 * 60
      when 'hour'
        multiplier = 60
      when 'min'
        multiplier = 1
      when 'sec'
        multiplier = 1.to_f/60
      end

      return multiplier * time.to_f
    end
  end
end