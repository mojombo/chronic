require 'strscan'

module Chronic
  class Numerizer
    def self.numerize(string)
      string = string.dup

      # preprocess
      string.gsub!(/ +|([^\d])-([^\d])/, '\1 \2') # will mutilate hyphenated-words but shouldn't matter for date extraction
      string.gsub!(/a half/, 'haAlf') # take the 'a' out so it doesn't turn into a 1, save the half for the end

      # easy/direct replacements

      Chronic.locale_hash[:numerizer][:direct_nums].each do |dn|
        string.gsub!(/#{dn[0]}/i, '<num>' + dn[1])
      end

      Chronic.locale_hash[:numerizer][:ordinals].each do |on|
        string.gsub!(/#{on[0]}/i, '<num>' + on[1] + on[0][-2, 2])
      end

      # ten, twenty, etc.

      Chronic.locale_hash[:numerizer][:ten_prefixes].each do |tp|
        string.gsub!(/(?:#{tp[0]}) *<num>(\d(?=[^\d]|$))*/i) { '<num>' + (tp[1] + $1.to_i).to_s }
      end

      Chronic.locale_hash[:numerizer][:ten_prefixes].each do |tp|
        string.gsub!(/#{tp[0]}/i) { '<num>' + tp[1].to_s }
      end

      # hundreds, thousands, millions, etc.

      Chronic.locale_hash[:numerizer][:big_prefixes].each do |bp|
        string.gsub!(/(?:<num>)?(\d*) *#{bp[0]}/i) { '<num>' + (bp[1] * $1.to_i).to_s}
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
