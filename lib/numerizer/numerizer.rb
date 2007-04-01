require 'strscan'

class Numerizer

  DIRECT_NUMS = [
                  ['eleven', '11'],
                  ['twelve', '12'],
                  ['thirteen', '13'],
                  ['fourteen', '14'],
                  ['fifteen', '15'],
                  ['sixteen', '16'],
                  ['seventeen', '17'],
                  ['eighteen', '18'],
                  ['nineteen', '19'],
                  ['ninteen', '19'], # Common mis-spelling
                  ['zero', '0'],
                  ['one', '1'],
                  ['two', '2'],
                  ['three', '3'],
                  ['four(\W|$)', '4\1'],  # The weird regex is so that it matches four but not fourty
                  ['five', '5'],
                  ['six(\W|$)', '6\1'],
                  ['seven(\W|$)', '7\1'],
                  ['eight(\W|$)', '8\1'],
                  ['nine(\W|$)', '9\1'],
                  ['ten', '10'],
                  ['\ba[\b^$]', '1'] # doesn't make sense for an 'a' at the end to be a 1
                ]

  TEN_PREFIXES = [ ['twenty', 20],
                    ['thirty', 30],
                    ['fourty', 40],
                    ['fifty', 50],
                    ['sixty', 60],
                    ['seventy', 70],
                    ['eighty', 80],
                    ['ninety', 90]
                  ]

  BIG_PREFIXES = [ ['hundred', 100],
                    ['thousand', 1000],
                    ['million', 1_000_000],
                    ['billion', 1_000_000_000],
                    ['trillion', 1_000_000_000_000],
                  ]

class << self
  def numerize(string)
    string = string.dup
  
    # preprocess
    string.gsub!(/ +|([^\d])-([^d])/, '\1 \2') # will mutilate hyphenated-words but shouldn't matter for date extraction
    string.gsub!(/a half/, 'haAlf') # take the 'a' out so it doesn't turn into a 1, save the half for the end

    # easy/direct replacements
  
    DIRECT_NUMS.each do |dn|
      string.gsub!(/#{dn[0]}/i, dn[1])
    end

    # ten, twenty, etc.

    TEN_PREFIXES.each do |tp|
      string.gsub!(/(?:#{tp[0]})( *\d(?=[^\d]|$))*/i) { (tp[1] + $1.to_i).to_s }
    end

    # hundreds, thousands, millions, etc.

    BIG_PREFIXES.each do |bp|
      string.gsub!(/(\d*) *#{bp[0]}/i) { (bp[1] * $1.to_i).to_s}
      andition(string)
      #combine_numbers(string) # Should to be more efficient way to do this
    end

    # fractional addition
    # I'm not combining this with the previous block as using float addition complicates the strings
    # (with extraneous .0's and such )
    string.gsub!(/(\d+)(?: | and |-)*haAlf/i) { ($1.to_f + 0.5).to_s }

    string
  end

private
  def andition(string)
    sc = StringScanner.new(string)
    while(sc.scan_until(/(\d+)( | and )(\d+)(?=[^\w]|$)/i))
      if sc[2] =~ /and/ || sc[1].size > sc[3].size
        string[(sc.pos - sc.matched_size)..(sc.pos-1)] = (sc[1].to_i + sc[3].to_i).to_s
        sc.reset
      end
    end
  end

#  def combine_numbers(string)
#    sc = StringScanner.new(string)
#    while(sc.scan_until(/(\d+)(?: | and |-)(\d+)(?=[^\w]|$)/i))
#      string[(sc.pos - sc.matched_size)..(sc.pos-1)] = (sc[1].to_i + sc[2].to_i).to_s
#      sc.reset
#    end
#  end

end
end