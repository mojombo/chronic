module Chronic
  module Handlers
    module_function

    # Handle month/day
    def handle_m_d(month, day, time_tokens, options)
      month.start = Chronic.now
      span = month.this(options[:context])
      year, month = span.begin.year, span.begin.month
      day_start = Chronic.time_class.local(year, month, day)

      day_or_time(day_start, time_tokens, options)
    end

    # Handle repeater-month-name/scalar-day
    def handle_rmn_sd(tokens, options)
      month = tokens[0].get_tag(RepeaterMonthName)
      day = tokens[1].get_tag(ScalarDay).type

      return if month_overflow?(Chronic.now.year, month.index, day)

      handle_m_d(month, day, tokens[2..tokens.size], options)
    end

    # Handle repeater-month-name/scalar-day with separator-on
    def handle_rmn_sd_on(tokens, options)
      if tokens.size > 3
        month = tokens[2].get_tag(RepeaterMonthName)
        day = tokens[3].get_tag(ScalarDay).type
        token_range = 0..1
      else
        month = tokens[1].get_tag(RepeaterMonthName)
        day = tokens[2].get_tag(ScalarDay).type
        token_range = 0..0
      end

      return if month_overflow?(Chronic.now.year, month.index, day)

      handle_m_d(month, day, tokens[token_range], options)
    end

    # Handle repeater-month-name/ordinal-day
    def handle_rmn_od(tokens, options)
      month = tokens[0].get_tag(RepeaterMonthName)
      day = tokens[1].get_tag(OrdinalDay).type

      return if month_overflow?(Chronic.now.year, month.index, day)

      handle_m_d(month, day, tokens[2..tokens.size], options)
    end

    # Handle ordinal-day/repeater-month-name
    def handle_od_rmn(tokens, options)
      month = tokens[1].get_tag(RepeaterMonthName)
      day = tokens[0].get_tag(OrdinalDay).type

      return if month_overflow?(Chronic.now.year, month.index, day)

      handle_m_d(month, day, tokens[2..tokens.size], options)
    end

    def handle_sy_rmn_od(tokens, options)
      year = tokens[0].get_tag(ScalarYear).type
      month = tokens[1].get_tag(RepeaterMonthName).index
      day = tokens[2].get_tag(OrdinalDay).type
      time_tokens = tokens.last(tokens.size - 3)

      return if month_overflow?(year, month, day)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle scalar-day/repeater-month-name
    def handle_sd_rmn(tokens, options)
      month = tokens[1].get_tag(RepeaterMonthName)
      day = tokens[0].get_tag(ScalarDay).type

      return if month_overflow?(Chronic.now.year, month.index, day)

      handle_m_d(month, day, tokens[2..tokens.size], options)
    end

    # Handle repeater-month-name/ordinal-day with separator-on
    def handle_rmn_od_on(tokens, options)
      if tokens.size > 3
        month = tokens[2].get_tag(RepeaterMonthName)
        day = tokens[3].get_tag(OrdinalDay).type
        token_range = 0..1
      else
        month = tokens[1].get_tag(RepeaterMonthName)
        day = tokens[2].get_tag(OrdinalDay).type
        token_range = 0..0
      end

      return if month_overflow?(Chronic.now.year, month.index, day)

      handle_m_d(month, day, tokens[token_range], options)
    end

    # Handle repeater-month-name/scalar-year
    def handle_rmn_sy(tokens, options)
      month = tokens[0].get_tag(RepeaterMonthName).index
      year = tokens[1].get_tag(ScalarYear).type

      if month == 12
        next_month_year = year + 1
        next_month_month = 1
      else
        next_month_year = year
        next_month_month = month + 1
      end

      begin
        end_time = Chronic.time_class.local(next_month_year, next_month_month)
        Span.new(Chronic.time_class.local(year, month), end_time)
      rescue ArgumentError
        nil
      end
    end

    # Handle generic timestamp (ruby 1.8)
    def handle_rdn_rmn_sd_t_tz_sy(tokens, options)
      t = Chronic.time_class.parse(options[:text])
      Span.new(t, t + 1)
    end

    # Handle generic timestamp (ruby 1.9)
    def handle_sy_sm_sd_t_tz(tokens, options)
      t = Chronic.time_class.parse(options[:text])
      Span.new(t, t + 1)
    end

    # Handle repeater-month-name/scalar-day/scalar-year
    def handle_rmn_sd_sy(tokens, options)
      month = tokens[0].get_tag(RepeaterMonthName).index
      day = tokens[1].get_tag(ScalarDay).type
      year = tokens[2].get_tag(ScalarYear).type
      time_tokens = tokens.last(tokens.size - 3)

      return if month_overflow?(year, month, day)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle repeater-month-name/ordinal-day/scalar-year
    def handle_rmn_od_sy(tokens, options)
      month = tokens[0].get_tag(RepeaterMonthName).index
      day = tokens[1].get_tag(OrdinalDay).type
      year = tokens[2].get_tag(ScalarYear).type
      time_tokens = tokens.last(tokens.size - 3)

      return if month_overflow?(year, month, day)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle oridinal-day/repeater-month-name/scalar-year
    def handle_od_rmn_sy(tokens, options)
      day = tokens[0].get_tag(OrdinalDay).type
      month = tokens[1].get_tag(RepeaterMonthName).index
      year = tokens[2].get_tag(ScalarYear).type
      time_tokens = tokens.last(tokens.size - 3)

      return if month_overflow?(year, month, day)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle scalar-day/repeater-month-name/scalar-year
    def handle_sd_rmn_sy(tokens, options)
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      time_tokens = tokens.last(tokens.size - 3)
      handle_rmn_sd_sy(new_tokens + time_tokens, options)
    end

    # Handle scalar-month/scalar-day/scalar-year (endian middle)
    def handle_sm_sd_sy(tokens, options)
      month = tokens[0].get_tag(ScalarMonth).type
      day = tokens[1].get_tag(ScalarDay).type
      year = tokens[2].get_tag(ScalarYear).type
      time_tokens = tokens.last(tokens.size - 3)

      return if month_overflow?(year, month, day)

      begin
        day_start = Chronic.time_class.local(year, month, day)
        day_or_time(day_start, time_tokens, options)
      rescue ArgumentError
        nil
      end
    end

    # Handle scalar-day/scalar-month/scalar-year (endian little)
    def handle_sd_sm_sy(tokens, options)
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      time_tokens = tokens.last(tokens.size - 3)
      handle_sm_sd_sy(new_tokens + time_tokens, options)
    end

    # Handle scalar-year/scalar-month/scalar-day
    def handle_sy_sm_sd(tokens, options)
      new_tokens = [tokens[1], tokens[2], tokens[0]]
      time_tokens = tokens.last(tokens.size - 3)
      handle_sm_sd_sy(new_tokens + time_tokens, options)
    end

    # Handle scalar-month/scalar-year
    def handle_sm_sy(tokens, options)
      month = tokens[0].get_tag(ScalarMonth).type
      year = tokens[1].get_tag(ScalarYear).type

      if month == 12
        next_month_year = year + 1
        next_month_month = 1
      else
        next_month_year = year
        next_month_month = month + 1
      end

      begin
        end_time = Chronic.time_class.local(next_month_year, next_month_month)
        Span.new(Chronic.time_class.local(year, month), end_time)
      rescue ArgumentError
        nil
      end
    end

    # Handle RepeaterDayName RepeaterMonthName OrdinalDay
    def handle_rdn_rmn_od(tokens, options)
      month = tokens[1].get_tag(RepeaterMonthName)
      day = tokens[2].get_tag(OrdinalDay).type
      year = Chronic.now.year

      return if month_overflow?(year, month.index, day)

      begin
        start_time = Chronic.time_class.local(year, month.index, day)
        end_time = time_with_rollover(year, month.index, day + 1)
        Span.new(start_time, end_time)
      rescue ArgumentError
        nil
      end
    end

    # Handle RepeaterDayName RepeaterMonthName ScalarDay
    def handle_rdn_rmn_sd(tokens, options)
      month = tokens[1].get_tag(RepeaterMonthName)
      day = tokens[2].get_tag(ScalarDay).type
      year = Chronic.now.year

      return if month_overflow?(year, month.index, day)

      begin
        start_time = Chronic.time_class.local(year, month.index, day)
        end_time = time_with_rollover(year, month.index, day + 1)
        Span.new(start_time, end_time)
      rescue ArgumentError
        nil
      end
    end

    # Handle RepeaterDayName RepeaterMonthName ScalarDay ScalarYear
    def handle_rdn_rmn_sd_sy(tokens, options)
      month = tokens[1].get_tag(RepeaterMonthName)
      day = tokens[2].get_tag(ScalarDay).type
      year = tokens[3].get_tag(ScalarYear).type

      return if month_overflow?(year, month.index, day)

      begin
        start_time = Chronic.time_class.local(year, month.index, day)
        end_time = time_with_rollover(year, month.index, day + 1)
        Span.new(start_time, end_time)
      rescue ArgumentError
        nil
      end
    end

    # anchors

    # Handle repeaters
    def handle_r(tokens, options)
      dd_tokens = dealias_and_disambiguate_times(tokens, options)
      get_anchor(dd_tokens, options)
    end

    # Handle repeater/grabber/repeater
    def handle_r_g_r(tokens, options)
      new_tokens = [tokens[1], tokens[0], tokens[2]]
      handle_r(new_tokens, options)
    end

    # arrows

    # Handle scalar/repeater/pointer helper
    def handle_srp(tokens, span, options)
      distance = tokens[0].get_tag(Scalar).type
      repeater = tokens[1].get_tag(Repeater)
      pointer = tokens[2].get_tag(Pointer).type

      repeater.offset(span, distance, pointer)
    end

    # Handle scalar/repeater/pointer
    def handle_s_r_p(tokens, options)
      repeater = tokens[1].get_tag(Repeater)
      span = Span.new(Chronic.now, Chronic.now + 1)

      handle_srp(tokens, span, options)
    end

    # Handle pointer/scalar/repeater
    def handle_p_s_r(tokens, options)
      new_tokens = [tokens[1], tokens[2], tokens[0]]
      handle_s_r_p(new_tokens, options)
    end

    # Handle scalar/repeater/pointer/anchor
    def handle_s_r_p_a(tokens, options)
      anchor_span = get_anchor(tokens[3..tokens.size - 1], options)
      handle_srp(tokens, anchor_span, options)
    end

    # narrows

    # Handle oridinal repeaters
    def handle_orr(tokens, outer_span, options)
      repeater = tokens[1].get_tag(Repeater)
      repeater.start = outer_span.begin - 1
      ordinal = tokens[0].get_tag(Ordinal).type
      span = nil

      ordinal.times do
        span = repeater.next(:future)

        if span.begin >= outer_span.end
          span = nil
          break
        end
      end

      span
    end

    # Handle ordinal/repeater/separator/repeater
    def handle_o_r_s_r(tokens, options)
      outer_span = get_anchor([tokens[3]], options)
      handle_orr(tokens[0..1], outer_span, options)
    end

    # Handle ordinal/repeater/grabber/repeater
    def handle_o_r_g_r(tokens, options)
      outer_span = get_anchor(tokens[2..3], options)
      handle_orr(tokens[0..1], outer_span, options)
    end

    # support methods

    def day_or_time(day_start, time_tokens, options)
      outer_span = Span.new(day_start, day_start + (24 * 60 * 60))

      if !time_tokens.empty?
        Chronic.now = outer_span.begin
        get_anchor(dealias_and_disambiguate_times(time_tokens, options), options)
      else
        outer_span
      end
    end

    def get_anchor(tokens, options)
      grabber = Grabber.new(:this)
      pointer = :future

      repeaters = get_repeaters(tokens)
      repeaters.size.times { tokens.pop }

      if tokens.first && tokens.first.get_tag(Grabber)
        grabber = tokens.shift.get_tag(Grabber)
      end

      head = repeaters.shift
      head.start = Chronic.now

      case grabber.type
      when :last
        outer_span = head.next(:past)
      when :this
        if options[:context] != :past and repeaters.size > 0
          outer_span = head.this(:none)
        else
          outer_span = head.this(options[:context])
        end
      when :next
        outer_span = head.next(:future)
      else
        raise ChronicPain, "Invalid grabber"
      end

      if Chronic.debug
        puts "Handler-class: #{head.class}"
        puts "--#{outer_span}"
      end

      find_within(repeaters, outer_span, pointer)
    end

    def get_repeaters(tokens)
      tokens.map { |token| token.get_tag(Repeater) }.compact.sort.reverse
    end

    def month_overflow?(year, month, day)
      if Date.leap?(year)
        day > RepeaterMonth::MONTH_DAYS_LEAP[month - 1]
      else
        day > RepeaterMonth::MONTH_DAYS[month - 1]
      end
    end

    # Recursively finds repeaters within other repeaters.
    # Returns a Span representing the innermost time span
    # or nil if no repeater union could be found
    def find_within(tags, span, pointer)
      puts "--#{span}" if Chronic.debug
      return span if tags.empty?

      head = tags.shift
      head.start = (pointer == :future ? span.begin : span.end)
      h = head.this(:none)

      if span.cover?(h.begin) || span.cover?(h.end)
        find_within(tags, h, pointer)
      end
    end

    def time_with_rollover(year, month, day)
      date_parts =
        if month_overflow?(year, month, day)
          if month == 12
            [year + 1, 1, 1]
          else
            [year, month + 1, 1]
          end
        else
          [year, month, day]
        end
      Chronic.time_class.local(*date_parts)
    end

    def dealias_and_disambiguate_times(tokens, options)
      # handle aliases of am/pm
      # 5:00 in the morning -> 5:00 am
      # 7:00 in the evening -> 7:00 pm

      day_portion_index = nil
      tokens.each_with_index do |t, i|
        if t.get_tag(RepeaterDayPortion)
          day_portion_index = i
          break
        end
      end

      time_index = nil
      tokens.each_with_index do |t, i|
        if t.get_tag(RepeaterTime)
          time_index = i
          break
        end
      end

      if day_portion_index && time_index
        t1 = tokens[day_portion_index]
        t1tag = t1.get_tag(RepeaterDayPortion)

        case t1tag.type
        when :morning
          puts '--morning->am' if Chronic.debug
          t1.untag(RepeaterDayPortion)
          t1.tag(RepeaterDayPortion.new(:am))
        when :afternoon, :evening, :night
          puts "--#{t1tag.type}->pm" if Chronic.debug
          t1.untag(RepeaterDayPortion)
          t1.tag(RepeaterDayPortion.new(:pm))
        end
      end

      # handle ambiguous times if :ambiguous_time_range is specified
      if options[:ambiguous_time_range] != :none
        ambiguous_tokens = []

        tokens.each_with_index do |token, i|
          ambiguous_tokens << token
          next_token = tokens[i + 1]

          if token.get_tag(RepeaterTime) && token.get_tag(RepeaterTime).type.ambiguous? && (!next_token || !next_token.get_tag(RepeaterDayPortion))
            distoken = Token.new('disambiguator')

            distoken.tag(RepeaterDayPortion.new(options[:ambiguous_time_range]))
            ambiguous_tokens << distoken
          end
        end

        tokens = ambiguous_tokens
      end

      tokens
    end

  end

end
