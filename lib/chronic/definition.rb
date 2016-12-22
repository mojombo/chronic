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
        Handler.new([:repeater_time, :repeater_day_portion?], nil)
      ]
    end
  end

  class DateDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :repeater_time, [:separator_slash?, :separator_dash?], :time_zone, :scalar_year], :handle_generic),
        Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day], :handle_rdn_rmn_sd),
        Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :scalar_year], :handle_rdn_rmn_sd_sy),
        Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day], :handle_rdn_rmn_od),
        Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day, :scalar_year], :handle_rdn_rmn_od_sy),
        Handler.new([:repeater_day_name, :repeater_month_name, :scalar_day, :separator_at?, 'time?'], :handle_rdn_rmn_sd),
        Handler.new([:repeater_day_name, :repeater_month_name, :ordinal_day, :separator_at?, 'time?'], :handle_rdn_rmn_od),
        Handler.new([:repeater_day_name, :ordinal_day, :separator_at?, 'time?'], :handle_rdn_od),
        Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_day, :repeater_time, :time_zone], :handle_generic),
        Handler.new([:ordinal_day], :handle_generic),
        Handler.new([:repeater_month_name, :scalar_day, :scalar_year], :handle_rmn_sd_sy),
        Handler.new([:repeater_month_name, :ordinal_day, :scalar_year], :handle_rmn_od_sy),
        Handler.new([:repeater_month_name, :scalar_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_sd_sy),
        Handler.new([:repeater_month_name, :ordinal_day, :scalar_year, :separator_at?, 'time?'], :handle_rmn_od_sy),
        Handler.new([:repeater_month_name, [:separator_slash?, :separator_dash?], :scalar_day, :separator_at?, 'time?'], :handle_rmn_sd),
        Handler.new([:repeater_time, :repeater_day_portion?, :separator_on?, :repeater_month_name, :scalar_day], :handle_rmn_sd_on),
        Handler.new([:repeater_month_name, :ordinal_day, :separator_at?, 'time?'], :handle_rmn_od),
        Handler.new([:ordinal_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_od_rmn_sy),
        Handler.new([:ordinal_day, :repeater_month_name, :separator_at?, 'time?'], :handle_od_rmn),
        Handler.new([:ordinal_day, :grabber?, :repeater_month, :separator_at?, 'time?'], :handle_od_rm),
        Handler.new([:scalar_year, :repeater_month_name, :ordinal_day], :handle_sy_rmn_od),
        Handler.new([:repeater_time, :repeater_day_portion?, :separator_on?, :repeater_month_name, :ordinal_day], :handle_rmn_od_on),
        Handler.new([:repeater_month_name, :scalar_year], :handle_rmn_sy),
        Handler.new([:repeater_quarter_name, :scalar_year], :handle_rqn_sy),
        Handler.new([:scalar_year, :repeater_quarter_name], :handle_sy_rqn),
        Handler.new([:scalar_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_sd_rmn_sy),
        Handler.new([:scalar_day, [:separator_slash?, :separator_dash?], :repeater_month_name, :separator_at?, 'time?'], :handle_sd_rmn),
        Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_day, :separator_at?, 'time?'], :handle_sy_sm_sd),
        Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month], :handle_sy_sm),
        Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_year], :handle_sm_sy),
        Handler.new([:scalar_day, [:separator_slash, :separator_dash], :repeater_month_name, [:separator_slash, :separator_dash], :scalar_year, :repeater_time?], :handle_sm_rmn_sy),
        Handler.new([:scalar_year, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar?, :time_zone], :handle_generic),
      ]
    end
  end

  class AnchorDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:separator_on?, :grabber?, :repeater, :separator_at?, :repeater?, :repeater?], :handle_r),
        Handler.new([:grabber?, :repeater, :repeater, :separator?, :repeater?, :repeater?], :handle_r),
        Handler.new([:repeater, :grabber, :repeater], :handle_r_g_r)
      ]
    end
  end

  class ArrowDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:repeater_month_name, :scalar, :repeater, :pointer], :handle_rmn_s_r_p),
        Handler.new([:scalar, :repeater, :pointer], :handle_s_r_p),
        Handler.new([:scalar, :repeater, :separator_and?, :scalar, :repeater, :pointer, :separator_at?, 'anchor'], :handle_s_r_a_s_r_p_a),
        Handler.new([:pointer, :scalar, :repeater], :handle_p_s_r),
        Handler.new([:scalar, :repeater, :pointer, :separator_at?, 'anchor'], :handle_s_r_p_a)
      ]
    end
  end

  class NarrowDefinitions < SpanDefinitions
    def definitions
      [
        Handler.new([:ordinal, :repeater, :separator_in, :repeater], :handle_o_r_s_r),
        Handler.new([:ordinal, :repeater, :grabber, :repeater], :handle_o_r_g_r)
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
        Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_day, [:separator_slash, :separator_dash], :scalar_year, :separator_at?, 'time?'], :handle_sm_sd_sy),
        Handler.new([:scalar_month, [:separator_slash, :separator_dash], :scalar_day, :separator_at?, 'time?'], :handle_sm_sd),
        Handler.new([:scalar_day, [:separator_slash, :separator_dash], :scalar_month, :separator_at?, 'time?'], :handle_sd_sm),
        Handler.new([:scalar_day, [:separator_slash, :separator_dash], :scalar_month, [:separator_slash, :separator_dash], :scalar_year, :separator_at?, 'time?'], :handle_sd_sm_sy),
        Handler.new([:scalar_day, :repeater_month_name, :scalar_year, :separator_at?, 'time?'], :handle_sd_rmn_sy)
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
