require 'strscan'

module Chronic
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

    ORDINALS = [
      ['first', '1'],
      ['third', '3'],
      ['fourth', '4'],
      ['fifth', '5'],
      ['sixth', '6'],
      ['seventh', '7'],
      ['eighth', '8'],
      ['ninth', '9'],
      ['tenth', '10'],
      ['twelfth', '12'],
      ['twentieth', '20'],
      ['thirtieth', '30'],
      ['fourtieth', '40'],
      ['fiftieth', '50'],
      ['sixtieth', '60'],
      ['seventieth', '70'],
      ['eightieth', '80'],
      ['ninetieth', '90']
    ]

    TEN_PREFIXES = [
      ['twenty', 20],
      ['thirty', 30],
      ['forty', 40],
      ['fourty', 40], # Common mis-spelling
      ['fifty', 50],
      ['sixty', 60],
      ['seventy', 70],
      ['eighty', 80],
      ['ninety', 90]
    ]

    BIG_PREFIXES = [
      ['hundred', 100],
      ['thousand', 1000],
      ['million', 1_000_000],
      ['billion', 1_000_000_000],
      ['trillion', 1_000_000_000_000],
    ]

    def self.numerize(string)
      string = string.dup

      # preprocess
      string.gsub!(/ +|([^\d])-([^\d])/, '\1 \2') # will mutilate hyphenated-words but shouldn't matter for date extraction
      string.gsub!(/a half/, 'haAlf') # take the 'a' out so it doesn't turn into a 1, save the half for the end

      # easy/direct replacements

      DIRECT_NUMS.each do |dn|
        string.gsub!(/#{dn[0]}/i, '<num>' + dn[1])
      end

      ORDINALS.each do |on|
        string.gsub!(/#{on[0]}/i, '<num>' + on[1] + on[0][-2, 2])
      end

      # ten, twenty, etc.

      TEN_PREFIXES.each do |tp|
        string.gsub!(/(?:#{tp[0]}) *<num>(\d(?=[^\d]|$))*/i) { '<num>' + (tp[1] + $1.to_i).to_s }
      end

      TEN_PREFIXES.each do |tp|
        string.gsub!(/#{tp[0]}/i) { '<num>' + tp[1].to_s }
      end

      # hundreds, thousands, millions, etc.

      BIG_PREFIXES.each do |bp|
        string.gsub!(/(?:<num>)?(\d*) *#{bp[0]}/i) { $1.empty? ? bp[1] : '<num>' + (bp[1] * $1.to_i).to_s}
        andition(string)
      end

      # fractional addition
      # I'm not combining this with the previous block as using float addition complicates the strings
      # (with extraneous .0's and such )
      string.gsub!(/(\d+)(?: | and |-)*haAlf/i) { ($1.to_f + 0.5).to_s }

      string.gsub(/<num>/, '')
    end

    class << self
      private

      def andition(string)
        sc = StringScanner.new(string)

        while sc.scan_until(/<num>(\d+)( | and )<num>(\d+)(?=[^\w]|$)/i)
          if sc[2] =~ /and/ || sc[1].size > sc[3].size
            string[(sc.pos - sc.matched_size)..(sc.pos-1)] = '<num>' + (sc[1].to_i + sc[3].to_i).to_s
            sc.reset
          end
        end
      end

    end
  end
end