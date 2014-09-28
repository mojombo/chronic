require 'chronic/handlers/general'

module Chronic
  module ArrowHandlers
    include GeneralHandlers
    # Handle pointer
    # formats: p
    def handle_p
      @pointer = @tokens[@index].get_tag(Pointer).type
      next_tag
    end

    # Handle scalar/unit
    # formats: su, s u
    def handle_s_u
      handle_s
      handle_possible(SeparatorSpace)
      handle_u
    end

    # Handle unit/pointer
    # formats: su, s u
    def handle_u_p
      handle_u
      next_tag
      handle_p
      @count = 1
    end

    # Handle scalar/pointer
    # formats: s p
    def handle_s_p
      handle_s
      next_tag
      handle_p
      @unit = :minute
    end

    # Handle rational/pointer
    # formats: r p
    def handle_r_p
      handle_r
      next_tag
      handle_p
      @count = (@count * 60).to_i
      @unit = :minute
    end

    # Handle pointer/scalar/unit
    # formats: p su, s u
    def handle_p_s_u
      handle_p
      handle_possible(SeparatorSpace)
      handle_s_u
    end

    # Handle scalar/unit/pointer
    # formats: su p, s u p
    def handle_s_u_p
      handle_s_u
      next_tag
      handle_p
    end

    # Handle scalar/day-name
    # formats: s dn
    def handle_s_dn
      handle_s
      handle_possible(SeparatorSpace)
      handle_dn
      @special = @wday
      @unit = :wday
    end

    # Handle scalar/day-name/pointer
    # formats: s dn p
    def handle_s_dn_p
      handle_s_dn
      next_tag
      handle_p
    end

  end
end