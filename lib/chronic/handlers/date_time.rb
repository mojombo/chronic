require 'chronic/handlers/date'
require 'chronic/handlers/time'
require 'chronic/handlers/time_zone'

module Chronic
  module DateTimeHandlers
    include DateHandlers
    include TimeHandlers
    include TimeZoneHandlers

    # Handle scalar-year/scalar-month/scalar-day/scalar-hour/scalar-minute/scalar-second
    # formats: yyyy-mm-ddTh:m:s
    def handle_sy_sm_sd_h_m_s
      handle_sy_sm_sd
      next_tag # T
      handle_h_m_s
    end

    # Handle scalar-year/scalar-month/scalar-day/scalar-hour/scalar-minute/scalar-second
    # formats: yyyy-mm-ddTh:m:sZ
    def handle_sy_sm_sd_h_m_s_tz
      handle_sy_sm_sd
      next_tag # T
      handle_h_m_s
      handle_generic
    end

    # Handle scalar-year/scalar-month/scalar-day/scalar-hour/scalar-minute/scalar-second/scalar-subsecond
    # formats: yyyy-mm-ddTh:m:s.sss
    def handle_sy_sm_sd_h_m_s_ss
      handle_sy_sm_sd
      next_tag
      handle_h_m_s_ss
    end

    # Handle scalar-year/scalar-month/scalar-day/scalar-hour/scalar-minute/scalar-second/scalar-subsecond
    # formats: yyyy-mm-ddTh:m:s.sssZ
    def handle_sy_sm_sd_h_m_s_ss_tz
      handle_sy_sm_sd
      next_tag
      handle_h_m_s_ss
      handle_generic
    end

    # Handle scalar-year/scalar-month/scalar-day/scalar-hour/scalar-minute/scalar-second/sign/scalar-hour/scalar-minute
    # formats: yyyy-mm-ddTh:m:s+hh:mm
    def handle_sy_sm_sd_h_m_s_hh_mm
      handle_sy_sm_sd_h_m_s
      handle_hh_mm
    end

    # Handle scalar-year/scalar-month/scalar-day/scalar-hour/scalar-minute/scalar-second/scalar-subsecond/sign/scalar-hour/scalar-minute
    # formats: yyyy-mm-ddTh:m:s.sss +hh:mm
    def handle_sy_sm_sd_h_m_s_ss_hh_mm
      handle_sy_sm_sd_h_m_s_ss
      handle_hh_mm
    end

    # Handle day-name/month-name/scalar-day/scalar-hour/scalar-minute/scalar-second/abbr/scalar-year
    # formats: dn month dd h:m:s abbr yyyy
    def handle_dn_mn_sd_h_m_s_abbr_sy
      handle_dn_mn_sd
      next_tag
      handle_h_m_s
      next_tag
      handle_abbr
      next_tag
      handle_sy
    end

  end
end
