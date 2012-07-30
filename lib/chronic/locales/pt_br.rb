module Chronic
  module Locales
    PT_BR = {
      :numerizer => {
        :direct_nums => [
          ['onze', '11'],
          ['doze', '12'],
          ['treze', '13'],
          ['quartorze', '14'],
          ['catorze', '14'],
          ['quinze', '15'],
          ['dezesseis', '16'],
          ['dezeseis', '16'],
          ['dezessete', '17'],
          ['dezesete', '17'],
          ['dezoito', '18'],
          ['dezenove', '19'],
          ['zero', '0'],
          ['um', '1'],
          ['uma', '1'],
          ['dois', '2'],
          ['duas', '2'],
          ['tres', '3'],
          ['quatro', '4'],  # The weird regex is so that it matches four but not fourty
          ['cinco', '5'],
          ['seis', '6'],
          ['sete', '7'],
          ['oito', '8'],
          ['nove', '9'],
          ['dez(\W|$)', '10\1']
        ],
        :ordinals => [
          ['primeiro', '1'],
          ['terceiro', '3'],
          ['quarto', '4'],
          ['quinto', '5'],
          ['sexto', '6'],
          ['setimo', '7'],
          ['oitavo', '8'],
          ['nono', '9'],
          ['decimo', '10']
        ],
        :ten_prefixes => [
          ['vinte', 20],
          ['trinta', 30],
          ['quarenta', 40],
          ['cinquenta', 50],
          ['cincuenta', 50],
          ['sessenta', 60],
          ['setenta', 70],
          ['oitenta', 80],
          ['noventa', 90]
        ],
        :big_prefixes => [
          ['cem', 100],
          ['mil', 1000],
          ['milhao', 1_000_000],
          ['bilhao', 1_000_000_000],
          ['trilhao', 1_000_000_000_000],
        ],
      },

      :repeater => {
        :season_names => {
          /^primaveras?$/ => :spring,
          /^ver(ao|oes)$/ => :summer,
          /^outonos?$/ => :autumn,
          /^invernos?$/ => :winter
        },
        :month_names => {
          /^jan\.?(eiro)?$/ => :january,
          /^fev\.?(ereiro)?$/ => :february,
          /^mar\.?(co)?$/ => :march,
          /^abr\.?(il)?$/ => :april,
          /^mai\.?o?$/ => :may,
          /^jun\.?(ho)?$/ => :june,
          /^jul\.?(ho)?$/ => :july,
          /^ago\.?(sto)?$/ => :august,
          /^set\.?(embro)?$/ => :september,
          /^out\.?(ubro)?$/ => :october,
          /^nov\.?(embro)?$/ => :november,
          /^dez\.?(embro)?$/ => :december
        },
        :day_names => {
          /^seg(unda)?(-feira)?$/ => :monday,
          /^ter(ca)?(-feira)?$/ => :tuesday,
          /^qua(rta)?(-feira)?$/ => :wednesday,
          /^qui(nta)?(-feira)?$/ => :thursday,
          /^sex(ta)?(-feira)?$/ => :friday,
          /^sab(ado)?$/ => :saturday,
          /^dom(ingo)?$/ => :sunday
        },
        :day_portions => {
          /^ams?$/ => :am,
          /^pms?$/ => :pm,
          /^manhas?$/ => :morning,
          /^tardes?$/ => :afternoon,
          /^noites?$/ => :evening,
          /^(noite|madrugada)s?$/ => :night
        },
        :units => {
          /^anos?$/ => :year,
          /^estacoes?$/ => :season,
          /^meses?$/ => :month,
          /^quinzenas?$/ => :fortnight,
          /^semanas?$/ => :week,
          /^fi(m|ns) de semanas?$/ => :weekend,
          /^dias? uteis?$/ => :weekday,
          /^dias?$/ => :day,
          /^hrs?$/ => :hour,
          /^horas?$/ => :hour,
          /^mins?$/ => :minute,
          /^minutos?$/ => :minute,
          /^secs?$/ => :second,
          /^segundos?$/ => :second
        }
      },

      :pre_normalize => {
        :pre_numerize => [
          [/\./, ':'],
          [/['"]/, ''],
          [/,/, ' '],
          [/^segundo /, '2nd '],
          [/\bsegundo (de|dia|mes|hora|ninuto|segundo)\b/, '2nd \1']
        ],
        :pos_numerize => [
          [/ \-(\d{4})\b/, ' tzminus\1'],
          [/([\/\-\,\@])/, ' \1 '],
          [/(?:^|\s)0(\d+:\d+\s*pm?\b)/, ' \1'],
          [/\bhoje\b/, 'este dia'],
          [/\bamanha\b/, 'proximo dia'],
          [/\bontem\b/, 'ultimo dia'],
          [/\bmeio[- ]dia\b/, '12:00pm'],
          [/\bmeia[- ]noite\b/, '24:00'],
          [/\bagora\b/, 'este segundo'],
          [/\b(?:atras)\b/, 'passado'],
          [/\beste (?:ultimo|passado)\b/, 'ultimo'],
          [/\b(?:da|de) (madrugada|manha)\b/, '\1'],
          [/\b(?:da|de|a) (tarde|noite)\b/, '\1'],
          [/\bhoje a noite\b/, 'esta noite'],
          [/\b\d+:?\d*[ap]\b/,'\0m'],
          [/(\d)([ap]m|h|oclock)\b/, '\1 \2'],
          [/\b(depois|de agora)\b/, 'futuro'],
          [/^\s?an? /i, '1 ']
        ]
      },

      :grabber => {
        /ultim[ao]/ => :last,
        /est[ae]/ => :this,
        /proxim[ao]/ => :next
      },

      :token => {
        :comma => /^,$/,
        :at => /^(as|@)$/,
        :in => /^em$/,
        :on => /^em$/
      }
    }
  end
end
