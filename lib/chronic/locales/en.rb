class Chronic::Locale::En < Chronic::Locale

  LOCALE_HASH = {
      repeater:  {
          scan_for_season_names: {
              /^springs?$/          => :spring,
              /^summers?$/          => :summer,
              /^(autumn)|(fall)s?$/ => :autumn,
              /^winters?$/          => :winter
          },
          scan_for_month_names:  {
              /^jan[:\.]?(uary)?$/           => :january,
              /^feb[:\.]?(ruary)?$/          => :february,
              /^mar[:\.]?(ch)?$/             => :march,
              /^apr[:\.]?(il)?$/             => :april,
              /^may$/                        => :may,
              /^jun[:\.]?e?$/                => :june,
              /^jul[:\.]?y?$/                => :july,
              /^aug[:\.]?(ust)?$/            => :august,
              /^sep[:\.]?(t[:\.]?|tember)?$/ => :september,
              /^oct[:\.]?(ober)?$/           => :october,
              /^nov[:\.]?(ember)?$/          => :november,
              /^dec[:\.]?(ember)?$/          => :december,
          },
          scan_for_day_names:    {
              /^m[ou]n(day)?$/             => :monday,
              /^t(ue|eu|oo|u)s?(day)?$/    => :tuesday,
              /^we(d|dnes|nds|nns)(day)?$/ => :wednesday,
              /^th(u|ur|urs|ers)(day)?$/   => :thursday,
              /^fr[iy](day)?$/             => :friday,
              /^sat(t?[ue]rday)?$/         => :saturday,
              /^su[nm](day)?$/             => :sunday
          },
          scan_for_day_portions: {
              /^ams?$/           => :am,
              /^pms?$/           => :pm,
              /^mornings?$/      => :morning,
              /^afternoons?$/    => :afternoon,
              /^evenings?$/      => :evening,
              /^(night|nite)s?$/ => :night
          },
          scan_for_times:        /^\d{1,2}(:?\d{1,2})?([\.:]?\d{1,2}([\.:]\d{1,6})?)?$/,
          scan_for_units:        {
              /^years?$/               => :year,
              /^seasons?$/             => :season,
              /^months?$/              => :month,
              /^fortnights?$/          => :fortnight,
              /^weeks?$/               => :week,
              /^weekends?$/            => :weekend,
              /^(week|business)days?$/ => :weekday,
              /^days?$/                => :day,
              /^hrs?$/                 => :hour,
              /^hours?$/               => :hour,
              /^mins?$/                => :minute,
              /^minutes?$/             => :minute,
              /^secs?$/                => :second,
              /^seconds?$/             => :second
          }
      },
      grabber:   {
          scan_for_all: {
              /last/ => :last,
              /this/ => :this,
              /next/ => :next
          }
      },
      pointer:   {
          scan_for_all: {
              /\bpast\b/          => :past,
              /\b(?:future|in)\b/ => :future,
          }
      },
      separator: {
          comma:          /^,$/,
          dot:            /^\.$/,
          colon:          /^:$/,
          space:          /^ $/,
          slash:          /^\/$/,
          dash:           /^-$/,
          scan_for_quote: {
              /^'$/ => :single_quote,
              /^"$/ => :double_quote
          },
          at:             /^(at|@)$/,
          in:             /^in$/,
          on:             /^on$/,
          and:            /^and$/,
          t:              /^t$/,
          w:              /^w$/
      }
  }

  def pre_normalize(text)
    text = text.to_s.downcase
    text.gsub!(/\b(\d{2})\.(\d{2})\.(\d{4})\b/, '\3 / \2 / \1')
    text.gsub!(/\b([ap])\.m\.?/, '\1m')
    text.gsub!(/(\s+|:\d{2}|:\d{2}\.\d{3})\-(\d{2}:?\d{2})\b/, '\1tzminus\2')
    text.gsub!(/\./, ':')
    text.gsub!(/([ap]):m:?/, '\1m')
    text.gsub!(/['"]/, '')
    text.gsub!(/,/, ' ')
    text.gsub!(/^second /, '2nd ')
    text.gsub!(/\bsecond (of|day|month|hour|minute|second)\b/, '2nd \1')
    text = Numerizer.numerize(text)
    text.gsub!(/([\/\-\,\@])/) { ' ' + $1 + ' ' }
    text.gsub!(/(?:^|\s)0(\d+:\d+\s*pm?\b)/, ' \1')
    text.gsub!(/\btoday\b/, 'this day')
    text.gsub!(/\btomm?orr?ow\b/, 'next day')
    text.gsub!(/\byesterday\b/, 'last day')
    text.gsub!(/\bnoon\b/, '12:00pm')
    text.gsub!(/\bmidnight\b/, '24:00')
    text.gsub!(/\bnow\b/, 'this second')
    text.gsub!('quarter', '15')
    text.gsub!('half', '30')
    text.gsub!(/(\d{1,2}) (to|till|prior to|before)\b/, '\1 minutes past')
    text.gsub!(/(\d{1,2}) (after|past)\b/, '\1 minutes future')
    text.gsub!(/\b(?:ago|before(?: now)?)\b/, 'past')
    text.gsub!(/\bthis (?:last|past)\b/, 'last')
    text.gsub!(/\b(?:in|during) the (morning)\b/, '\1')
    text.gsub!(/\b(?:in the|during the|at) (afternoon|evening|night)\b/, '\1')
    text.gsub!(/\btonight\b/, 'this night')
    text.gsub!(/\b\d+:?\d*[ap]\b/, '\0m')
    text.gsub!(/\b(\d{2})(\d{2})(am|pm)\b/, '\1:\2\3')
    text.gsub!(/(\d)([ap]m|oclock)\b/, '\1 \2')
    text.gsub!(/\b(hence|after|from)\b/, 'future')
    text.gsub!(/^\s?an? /i, '1 ')
    text.gsub!(/\b(\d{4}):(\d{2}):(\d{2})\b/, '\1 / \2 / \3') # DTOriginal
    text.gsub!(/\b0(\d+):(\d{2}):(\d{2}) ([ap]m)\b/, '\1:\2:\3 \4')
    text
  end
end
