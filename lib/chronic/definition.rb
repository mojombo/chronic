module Chronic
  # SpanDefinitions subclasses return definitions constructed by Handler instances (see handler.rb)
  # SpanDefinitions subclasses follow a <Type> + Definitions naming pattern
  # Types of Definitions are collected in Dictionaries (see dictionary.rb)
  class Definitions
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def definitions
      raise "definitions are set in subclasses of #{self.class}"
    end
  end

  class SpanDefinitions < Definitions
  end

  # Match only Time
  class TimeDefinitions < SpanDefinitions
    def definitions
      [
        [[SeparatorSpace, TimeSpecial, SeparatorSpace, [KeywordAt, :optional], [SeparatorSpace, :optional], ScalarHour, SeparatorColon, ScalarMinute], :handle_ts_h_m],
        [[SeparatorSpace, TimeSpecial, SeparatorSpace, [KeywordAt, :optional], [SeparatorSpace, :optional], ScalarHour], :handle_ts_h],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour,  SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, [SeparatorDot, SeparatorColon], ScalarSubsecond], :handle_h_m_s_ss],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour,  SeparatorColon, ScalarMinute, [SeparatorColon, SeparatorDot], ScalarSecond, [SeparatorSpace, :optional], DayPortion], :handle_h_m_s_dp],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour,  SeparatorColon, ScalarMinute, [SeparatorColon, SeparatorDot], ScalarSecond], :handle_h_m_s],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour, [SeparatorColon, SeparatorDot], ScalarMinute, SeparatorSpace, [KeywordIn, KeywordAt], SeparatorSpace, TimeSpecial], :handle_h_m_ts],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour, [SeparatorColon, SeparatorDot], ScalarMinute, [SeparatorSpace, :optional], DayPortion], :handle_h_m_dp],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour, [SeparatorColon, SeparatorDot], ScalarMinute], :handle_h_m],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarWide, [SeparatorSpace, :optional], DayPortion], :handle_hhmm_dp],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour,  SeparatorSpace, KeywordIn, SeparatorSpace, TimeSpecial], :handle_h_ts],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour,  SeparatorSpace, [KeywordAt, :optional], [SeparatorSpace, :optional], TimeSpecial], :handle_h_ts],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour, [SeparatorSpace, :optional], DayPortion], :handle_h_dp],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarWide,  SeparatorSpace], :handle_hhmm],
        [[[KeywordAt, :optional], SeparatorSpace, TimeSpecial], :handle_ts],
        [[[KeywordAt, :optional], SeparatorSpace, ScalarHour,  SeparatorSpace], :handle_h]
      ]
    end
  end

  # Match only Date
  class DateDefinitions < SpanDefinitions
    def definitions
      [
        [[DayName,    SeparatorSpace, MonthName,   SeparatorSpace, OrdinalDay, SeparatorSpace, ScalarYear], :handle_dn_mn_od_sy],
        [[DayName,    SeparatorSpace, MonthName,   SeparatorSpace, ScalarDay, SeparatorSpace, ScalarYear], :handle_dn_mn_sd_sy],
        [[DayName,    SeparatorSpace, MonthName,   SeparatorSpace, OrdinalDay], :handle_dn_mn_od],
        [[DayName,    SeparatorSpace, MonthName,   SeparatorSpace, ScalarDay], :handle_dn_mn_sd],
        [[MonthName,  SeparatorSpace, OrdinalDay, [SeparatorComma, SeparatorSpace], [SeparatorSpace, :optional], ScalarYear], :handle_mn_od_sy],
        [[MonthName,  SeparatorSpace, ScalarDay,  [SeparatorComma, :optional], [SeparatorSpace, :optional], ScalarYear], :handle_mn_sd_sy],
        [[ScalarYear, SeparatorSpace, MonthName,   SeparatorSpace, OrdinalDay], :handle_sy_mn_od],
        [[ScalarYear, SeparatorSpace, MonthName,   SeparatorSpace, ScalarDay], :handle_sy_mn_sd],
        [[ScalarYear, SeparatorSlash, ScalarMonth, SeparatorSlash, ScalarDay], :handle_sy_sm_sd],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay], :handle_sy_sm_sd],
        [[ScalarYear, SeparatorDot,   ScalarMonth, SeparatorDot,   ScalarDay], :handle_sy_sm_sd],
        [[ScalarYear, SeparatorColon, ScalarMonth, SeparatorColon, ScalarDay], :handle_sy_sm_sd],
        [[OrdinalDay, SeparatorSpace, MonthName,   SeparatorSpace, ScalarYear], :handle_od_mn_sy],
        [[ScalarDay,  SeparatorDash,  MonthName,   SeparatorDash,  ScalarYear], :handle_sd_mn_sy],
        [[ScalarDay,  SeparatorSpace, MonthName,   SeparatorSpace, ScalarYear], :handle_sd_mn_sy],
        [[ScalarDay,  SeparatorDot,   ScalarMonth, SeparatorDot,   ScalarYear], :handle_sd_sm_sy]
      ]
    end
  end

  # Match only Date in short form
  class ShortDateDefinitions < SpanDefinitions
    def definitions
      [
        [[DayName,    SeparatorSpace, OrdinalDay], :handle_dn_od],
        [[MonthName,  SeparatorSpace, OrdinalDay], :handle_mn_od],
        [[MonthName, [SeparatorSpace, SeparatorDash], ScalarDay, [SeparatorSpace, Unit, :none]], :handle_mn_sd],
        [[MonthName,  SeparatorSpace, ScalarYear], :handle_mn_sy],
        [[ScalarYear, [SeparatorDash, SeparatorSlash],   ScalarMonth], :handle_sy_sm],
        [[ScalarFullYear, SeparatorSpace, MonthName], :handle_sy_mn],
        [[OrdinalDay, SeparatorSpace, MonthName], :handle_od_mn],
        [[ScalarDay, [SeparatorSpace, SeparatorDash, :optional], MonthName], :handle_sd_mn],
        [[KeywordIn,  SeparatorSpace, MonthName], :handle_mn],
        [[DaySpecial], :handle_ds],
        [[MonthName],  :handle_mn],
        [[DayName],    :handle_dn],
        [[SeparatorSpace, ScalarYear, SeparatorSpace], :handle_sy],
        [[OrdinalDay],     :handle_od],
        [[ScalarFullYear], :handle_sy]
      ]
    end
  end

  # Match only TimeZone
  class TimezoneDefinitions < SpanDefinitions
    def definitions
      [
        [[[Sign, :optional], ScalarHour, SeparatorColon, ScalarMinute], :handle_hh_mm],
        [[Sign, ScalarWide], :handle_hhmm],
        [[TimeZoneAbbreviation], :handle_abbr],
        [[TimeZoneGeneric], :handle_generic]
      ]
    end
  end

  # Match full Date+Time, can be with TimeZone
  class DateTimeDefinitions < SpanDefinitions
    def definitions
      [
        [[DayName, SeparatorSpace, MonthName, SeparatorSpace, ScalarDay, SeparatorSpace, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, SeparatorSpace, TimeZoneAbbreviation, SeparatorSpace, ScalarYear], :handle_dn_mn_sd_h_m_s_abbr_sy],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay, SeparatorT, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, [SeparatorDot, SeparatorColon], ScalarSubsecond, Sign, ScalarHour, SeparatorColon, ScalarMinute], :handle_sy_sm_sd_h_m_s_ss_hh_mm],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay, SeparatorT, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, Sign, ScalarHour, SeparatorColon, ScalarMinute], :handle_sy_sm_sd_h_m_s_hh_mm],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay, SeparatorT, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, [SeparatorDot, SeparatorColon], ScalarSubsecond, TimeZoneGeneric], :handle_sy_sm_sd_h_m_s_ss_tz],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay, SeparatorT, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, [SeparatorDot, SeparatorColon], ScalarSubsecond], :handle_sy_sm_sd_h_m_s_ss],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay, SeparatorT, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond, TimeZoneGeneric], :handle_sy_sm_sd_h_m_s_tz],
        [[ScalarYear, SeparatorDash,  ScalarMonth, SeparatorDash,  ScalarDay, SeparatorT, ScalarHour, SeparatorColon, ScalarMinute, SeparatorColon, ScalarSecond], :handle_sy_sm_sd_h_m_s]
      ]
    end
  end

  class AnchorDefinitions < SpanDefinitions
    def definitions
      [
        [[Grabber, SeparatorSpace, DayName],     :handle_gr_dn],
        [[Grabber, SeparatorSpace, MonthName],   :handle_gr_mn],
        [[Grabber, SeparatorSpace, SeasonName],  :handle_gr_sn],
        [[Grabber, SeparatorSpace, TimeSpecial], :handle_gr_ts],
        [[Grabber, SeparatorSpace, Unit],        :handle_gr_u],
        [[KeywordIn, SeparatorSpace, Scalar, SeparatorSpace, Unit], :handle_in_s_u],
        [[DaySpecial], :handle_ds],
        [[Unit],       :handle_u]
      ]
    end
  end

  class ArrowDefinitions < SpanDefinitions
    def definitions
      [
        [[Pointer, [SeparatorSpace, :optional], Scalar, [SeparatorSpace, :optional], Unit], :handle_p_s_u],
        [[Scalar,  [SeparatorSpace, :optional], DayName, SeparatorSpace, Pointer], :handle_s_dn_p],
        [[Rational, SeparatorSpace, Pointer], :handle_r_p],
        [[Unit,     SeparatorSpace, Pointer], :handle_u_p],
        [[Scalar,  [SeparatorSpace, :optional], Unit], :handle_s_u],
        [[Scalar,  [SeparatorSpace, :optional], Pointer], :handle_s_p],
      ]
    end
  end

  class NarrowDefinitions < SpanDefinitions
    def definitions
      [
        [[Grabber,  SeparatorSpace, Ordinal, SeparatorSpace, Unit], :handle_gr_o_u],
        [[Ordinal,  SeparatorSpace, Unit], :handle_o_u],
        [[Ordinal,  SeparatorSpace, DayName], :handle_o_dn],
      ]
    end
  end

  # Date depending on endianess
  class EndianDefinitions < SpanDefinitions
    def definitions
      prefered_endian
    end

    def prefered_endian
      options[:endian_precedence] ||= [:middle, :little]

      middle = [
        [[ScalarMonth,  SeparatorSlash, ScalarDay,    SeparatorSlash, ScalarYear, [SeparatorDot, Scalar, :none]],  :handle_sm_sd_sy],
        [[ScalarMonth,  SeparatorDash,  ScalarDay,    SeparatorDash,  ScalarYear, [SeparatorDot, Scalar, :none]],  :handle_sm_sd_sy],
        [[ScalarMonth, [SeparatorSlash, SeparatorDash, SeparatorDot],  ScalarDay, [SeparatorSlash, :none]],  :handle_sm_sd]
      ]
      little = [
        [[ScalarDay,   SeparatorDash,  ScalarMonth,   SeparatorDash,  ScalarYear, [SeparatorDot, Scalar, :none]],  :handle_sd_sm_sy],
        [[ScalarDay,   SeparatorSlash, ScalarMonth,   SeparatorSlash, ScalarYear, [SeparatorDot, Scalar, :none]],  :handle_sd_sm_sy],
        [[ScalarDay,  [SeparatorSlash, SeparatorDash, SeparatorDot],  ScalarMonth, [SeparatorSlash, :none]], :handle_sd_sm]
      ]

      case endian = Array(options[:endian_precedence]).first
      when :little
        little + middle
      when :middle
        middle + little
      else
        raise ArgumentError, "Unknown endian option '#{endian}'"
      end
    end
  end

end
