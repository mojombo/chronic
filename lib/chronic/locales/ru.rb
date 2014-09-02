class Chronic::Locale::Ru < Chronic::Locale

  LOCALE_HASH = {
      repeater:  {
          scan_for_season_names: {},
          scan_for_month_names:  {
              /^янв[:\.]?(ар)?(ь|я)?$/   => :january,
              /^фев[:\.]?(рал)?(ь|я)?$/  => :february,
              /^мар[:\.]?(т)?(а)?$/      => :march,
              /^апр[:\.]?(ел)?(ь|я)?$/   => :april,
              /^ма(й|я)$/                => :may,
              /^июн[:\.]?(ь|я)?$/        => :june,
              /^июл[:\.]?(ь|я)?$/        => :july,
              /^авг[:\.]?(уст)?(а)?$/    => :august,
              /^сен[:\.]?(тябр)?(ь|я)?$/ => :september,
              /^окт[:\.]?(ябр)?(ь|я)?$/  => :october,
              /^ноя[:\.]?(бр)?(ь|я)?$/   => :november,
              /^дек[:\.]?(абр)?(ь|я)?$/  => :december,
          },
          scan_for_day_names:    {
              /^понедельник$/ => :monday,
              /^вторник$/     => :tuesday,
              /^среда$/       => :wednesday,
              /^четверг$/     => :thursday,
              /^пятница$/     => :friday,
              /^суббота$/     => :saturday,
              /^воскресение$/ => :sunday
          },
          scan_for_day_portions: {
              /^утра$/   => :am,
              /^вечера$/ => :pm
          },
          scan_for_times:        /^\d{1,2}(:?\d{1,2})?([\.:]?\d{1,2}([\.:]\d{1,6})?)?$/,
          scan_for_units:        {
              /^лет?$/          => :year,
              /^год(а)?$/       => :year,
              /^сезон(ов)?$/    => :season,
              /^месяц(ев)?$/    => :month,
              /^недел(я|ь)$/    => :week,
              /^выходн(ой|ых)$/ => :weekend,
              /^дн(я|ей)$/      => :day,
              /^час(ов)?(а)?$/  => :hour,
              /^мин(ут)?(а)?$/  => :minute,
              /^сек(унд)?(а)?$/ => :second,
          }
      },
      grabber:   {
          scan_for_all: {
              /прошлый/   => :last,
              /этот/      => :this,
              /следующий/ => :next
          }
      },
      pointer:   {
          scan_for_all: {
              /\bназад\b/     => :past,
              /\b(?:через)\b/ => :future,
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
          at:             /^в$/,
          in:             /^в$/,
          on:             /^в$/,
          and:            /^и$/,
          t:              /^t$/,
          w:              /^w$/
      }
  }


  def pre_normalize(text)
    text = text.to_s.downcase
    text.gsub!(/\b(\d{2})\.(\d{2})\.(\d{4})\b/, '\3 / \2 / \1')
    text.gsub!(/(\s+|:\d{2}|:\d{2}\.\d{3})\-(\d{2}:?\d{2})\b/, '\1tzminus\2')
    text.gsub!(/\./, ':')
    text.gsub!(/['"]/, '')
    text.gsub!(/,/, ' ')
    text = Numerizer.numerize(text)
    text.gsub!(/([\/\-\,\@])/) { ' ' + $1 + ' ' }
    text.gsub!(/(?:^|\s)0(\d+:\d+\s*pm?\b)/, ' \1')
    text.gsub!(/\b(\d{4}):(\d{2}):(\d{2})\b/, '\1 / \2 / \3') # DTOriginal
    text.gsub!(/\b0(\d+):(\d{2}):(\d{2}) ([ap]m)\b/, '\1:\2:\3 \4')
    text.gsub!(/\bсейчас\b/, 'эта секунда')
    text
  end
end
