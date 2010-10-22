Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'chronic'
  s.version           = '0.3.0'
  s.date              = '2010-10-22'
  s.rubyforge_project = 'chronic'

  s.summary     = "Natural language date/time parsing."
  s.description = "Chronic is a natural language date/time parser written in pure Ruby."

  s.authors  = ["Tom Preston-Werner"]
  s.email    = 'tom@mojombo.com'
  s.homepage = 'http://github.com/mojombo/chronic'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md HISTORY.md LICENSE]

  # = MANIFEST =
  s.files = %w[
    HISTORY.md
    LICENSE
    Manifest.txt
    README.md
    Rakefile
    benchmark/benchmark.rb
    chronic.gemspec
    lib/chronic.rb
    lib/chronic/chronic.rb
    lib/chronic/grabber.rb
    lib/chronic/handlers.rb
    lib/chronic/numerizer/numerizer.rb
    lib/chronic/ordinal.rb
    lib/chronic/pointer.rb
    lib/chronic/repeater.rb
    lib/chronic/repeaters/repeater_day.rb
    lib/chronic/repeaters/repeater_day_name.rb
    lib/chronic/repeaters/repeater_day_portion.rb
    lib/chronic/repeaters/repeater_fortnight.rb
    lib/chronic/repeaters/repeater_hour.rb
    lib/chronic/repeaters/repeater_minute.rb
    lib/chronic/repeaters/repeater_month.rb
    lib/chronic/repeaters/repeater_month_name.rb
    lib/chronic/repeaters/repeater_season.rb
    lib/chronic/repeaters/repeater_season_name.rb
    lib/chronic/repeaters/repeater_second.rb
    lib/chronic/repeaters/repeater_time.rb
    lib/chronic/repeaters/repeater_week.rb
    lib/chronic/repeaters/repeater_weekday.rb
    lib/chronic/repeaters/repeater_weekend.rb
    lib/chronic/repeaters/repeater_year.rb
    lib/chronic/scalar.rb
    lib/chronic/separator.rb
    lib/chronic/time_zone.rb
    test/helper.rb
    test/test_Chronic.rb
    test/test_DaylightSavings.rb
    test/test_Handler.rb
    test/test_Numerizer.rb
    test/test_RepeaterDayName.rb
    test/test_RepeaterFortnight.rb
    test/test_RepeaterHour.rb
    test/test_RepeaterMinute.rb
    test/test_RepeaterMonth.rb
    test/test_RepeaterMonthName.rb
    test/test_RepeaterTime.rb
    test/test_RepeaterWeek.rb
    test/test_RepeaterWeekday.rb
    test/test_RepeaterWeekend.rb
    test/test_RepeaterYear.rb
    test/test_Span.rb
    test/test_Time.rb
    test/test_Token.rb
    test/test_parsing.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
