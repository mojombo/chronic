require 'chronic/handlers'

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
    include Handlers
  end

  class TimeDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:RepeaterTime, :RepeaterDayPortion?], nil)
      ]
    end
  end

  class DateDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :ScalarDay, :RepeaterTime, [:SeparatorSlash?, :SeparatorDash?], :TimeZone, :ScalarYear], :handle_generic),
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :ScalarDay], :handle_rdn_rmn_sd),
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :ScalarDay, :ScalarYear], :handle_rdn_rmn_sd_sy),
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :OrdinalDay], :handle_rdn_rmn_od),
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :OrdinalDay, :ScalarYear], :handle_rdn_rmn_od_sy),
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :ScalarDay, :SeparatorAt?, "time?"], :handle_rdn_rmn_sd),
        Handler.new([:RepeaterDayName, :RepeaterMonthName, :OrdinalDay, :SeparatorAt?, "time?"], :handle_rdn_rmn_od),
        Handler.new([:RepeaterDayName, :OrdinalDay, :SeparatorAt?, "time?"], :handle_rdn_od),
        Handler.new([:ScalarYear, [:SeparatorSlash, :SeparatorDash], :ScalarMonth, [:SeparatorSlash, :SeparatorDash], :ScalarDay, :RepeaterTime, :TimeZone], :handle_generic),
        Handler.new([:OrdinalDay], :handle_generic),
        Handler.new([:RepeaterMonthName, :ScalarDay, :ScalarYear], :handle_rmn_sd_sy),
        Handler.new([:RepeaterMonthName, :OrdinalDay, :ScalarYear], :handle_rmn_od_sy),
        Handler.new([:RepeaterMonthName, :ScalarDay, :ScalarYear, :SeparatorAt?, "time?"], :handle_rmn_sd_sy),
        Handler.new([:RepeaterMonthName, :OrdinalDay, :ScalarYear, :SeparatorAt?, "time?"], :handle_rmn_od_sy),
        Handler.new([:RepeaterMonthName, [:SeparatorSlash?, :SeparatorDash?], :ScalarDay, :SeparatorAt?, "time?"], :handle_rmn_sd),
        Handler.new([:RepeaterTime, :RepeaterDayPortion?, :SeparatorOn?, :RepeaterMonthName, :ScalarDay], :handle_rmn_sd_on),
        Handler.new([:RepeaterMonthName, :OrdinalDay, :SeparatorAt?, "time?"], :handle_rmn_od),
        Handler.new([:OrdinalDay, :RepeaterMonthName, :ScalarYear, :SeparatorAt?, "time?"], :handle_od_rmn_sy),
        Handler.new([:OrdinalDay, :RepeaterMonthName, :SeparatorAt?, "time?"], :handle_od_rmn),
        Handler.new([:OrdinalDay, :Grabber?, :RepeaterMonth, :SeparatorAt?, "time?"], :handle_od_rm),
        Handler.new([:ScalarYear, :RepeaterMonthName, :OrdinalDay], :handle_sy_rmn_od),
        Handler.new([:RepeaterTime, :RepeaterDayPortion?, :SeparatorOn?, :RepeaterMonthName, :OrdinalDay], :handle_rmn_od_on),
        Handler.new([:RepeaterMonthName, :ScalarYear], :handle_rmn_sy),
        Handler.new([:ScalarDay, :RepeaterMonthName, :ScalarYear, :SeparatorAt?, "time?"], :handle_sd_rmn_sy),
        Handler.new([:ScalarDay, [:SeparatorSlash?, :SeparatorDash?], :RepeaterMonthName, :SeparatorAt?, "time?"], :handle_sd_rmn),
        Handler.new([:ScalarYear, [:SeparatorSlash, :SeparatorDash], :ScalarMonth, [:SeparatorSlash, :SeparatorDash], :ScalarDay, :SeparatorAt?, "time?"], :handle_sy_sm_sd),
        Handler.new([:ScalarYear, [:SeparatorSlash, :SeparatorDash], :ScalarMonth], :handle_sy_sm),
        Handler.new([:ScalarMonth, [:SeparatorSlash, :SeparatorDash], :ScalarYear], :handle_sm_sy),
        Handler.new([:ScalarDay, [:SeparatorSlash, :SeparatorDash], :RepeaterMonthName, [:SeparatorSlash, :SeparatorDash], :ScalarYear, :RepeaterTime?], :handle_sm_rmn_sy),
        Handler.new([:ScalarYear, [:SeparatorSlash, :SeparatorDash], :ScalarMonth, [:SeparatorSlash, :SeparatorDash], :Scalar?, :TimeZone], :handle_generic)
      ]
    end
  end

  class AnchorDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:SeparatorOn?, :Grabber?, :Repeater, :SeparatorAt?, :Repeater?, :Repeater?], :handle_r),
        Handler.new([:Grabber?, :Repeater, :Repeater, :Separator?, :Repeater?, :Repeater?], :handle_r),
        Handler.new([:Repeater, :Grabber, :Repeater], :handle_r_g_r)
      ]
    end
  end


  class ArrowDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:Scalar, :Repeater, :Pointer], :handle_s_r_p),
        Handler.new([:Scalar, :Repeater, :SeparatorAnd?, :Scalar, :Repeater, :Pointer, :SeparatorAt?, "anchor"], :handle_s_r_a_s_r_p_a),
        Handler.new([:Pointer, :Scalar, :Repeater], :handle_p_s_r),
        Handler.new([:Scalar, :Repeater, :Pointer, :SeparatorAt?, "anchor"], :handle_s_r_p_a)
      ]
    end
  end

  class NarrowDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:Ordinal, :Repeater, :SeparatorIn, :Repeater], :handle_o_r_s_r),
        Handler.new([:Ordinal, :Repeater, :Grabber, :Repeater], :handle_o_r_g_r),
      ]
    end
  end

  class EndianDefinitions < SpanDefinitions
    def definitions
      prefered_endian
    end

    def prefered_endian
      options[:endian_precedence] ||= [:middle, :little]

      definitions = [
        Handler.new([:ScalarMonth, [:SeparatorSlash, :SeparatorDash], :ScalarDay, [:SeparatorSlash, :SeparatorDash], :ScalarYear, :SeparatorAt?, "time?"], :handle_sm_sd_sy),
        Handler.new([:ScalarMonth, [:SeparatorSlash, :SeparatorDash], :ScalarDay, :SeparatorAt?, "time?"], :handle_sm_sd),
        Handler.new([:ScalarDay, [:SeparatorSlash, :SeparatorDash], :ScalarMonth, :SeparatorAt?, "time?"], :handle_sd_sm),
        Handler.new([:ScalarDay, [:SeparatorSlash, :SeparatorDash], :ScalarMonth, [:SeparatorSlash, :SeparatorDash], :ScalarYear, :SeparatorAt?, "time?"], :handle_sd_sm_sy),
        Handler.new([:ScalarDay, :RepeaterMonthName, :ScalarYear, :SeparatorAt?, "time?"], :handle_sd_rmn_sy)
      ]

      case endian = Array(options[:endian_precedence]).first
      when :little
        definitions.reverse
      when :middle
        definitions
      else
        raise ArgumentError, "Unknown endian option '#{endian}'"
      end
    end
  end

end
