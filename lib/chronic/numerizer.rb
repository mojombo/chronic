require 'strscan'

module Chronic
  class Numerizer
    def self.numerize(string)
      string = string.dup

      # preprocess
      Chronic.locale_hash[:numerizer][:preprocess].each do |pp|
        if pp[1].is_a? Proc
          string.gsub!(pp[0], &pp[1])
        else
          string.gsub!(pp[0], pp[1])
        end
      end

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
      Chronic.locale_hash[:numerizer][:fractional].each do |fc|
        if fc[1].is_a? Proc
          string.gsub!(fc[0], &fc[1])
        else
          string.gsub!(fc[0], fc[1])
        end
      end

      string.gsub(/<num>/, '')
    end

    class << self
      private

      def andition(string)
        sc = StringScanner.new(string)

        while sc.scan_until(/<num>(\d+)( | #{Chronic.locale_hash[:numerizer][:and]} )<num>(\d+)(?=[^\w]|$)/i)
          if sc[2] =~ /#{Chronic.locale_hash[:numerizer][:and]}/ || sc[1].size > sc[3].size
            string[(sc.pos - sc.matched_size)..(sc.pos-1)] = '<num>' + (sc[1].to_i + sc[3].to_i).to_s
            sc.reset
          end
        end
      end

    end
  end
end
