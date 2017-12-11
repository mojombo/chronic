require 'chronic/handlers/general'

module Chronic
  module AnchorHandlers
    include GeneralHandlers
    # Handle grabber/time_special
    # formats: gr ts
    def handle_gr_ts
      handle_gr
      handle_possible(SeparatorSpace)
      handle_ts
    end

    # Handle grabber/day-name
    # formats: gr dn
    def handle_gr_dn
      handle_gr
      next_tag
      handle_dn
    end

    # Handle grabber/month-name
    # formats: gr mn
    def handle_gr_mn
      handle_gr
      next_tag
      handle_mn
    end

    # Handle grabber/season-name
    # formats: gr sn
    def handle_gr_sn
      handle_gr
      next_tag
      handle_sn
    end

    # Handle grabber/unit
    # formats: gr u
    def handle_gr_u
      handle_gr
      next_tag
      handle_u
    end

    # Handle keyword-in/scalar/unit
    # formats: in s u
    def handle_in_s_u
      next_tag
      next_tag
      handle_s
      next_tag
      handle_u
    end

    # Handle grabber/keyword-q/scalar
    # formats: gr Qs
    def handle_gr_q_s
      handle_gr
      next_tag
      handle_q_s
    end

  end
end
