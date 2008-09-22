SPEC = Gem::Specification.new do |s|
  s.name = 'chronic'
  s.version = '0.3.0'
  s.author = 'Tom Preston-Werner'
  s.email = 'tom@rubyisawesome.com'
  s.homepage = 'http://chronic.rubyforge.org'
  s.platform = Gem::Platform::RUBY
  s.summary = "A natural language date parser with timezone support"
  # Explicitly list all files because Dir[] is incompatible with safelevel 3
  # Just run irb >> Dir["{lib,test}/**/*"] to get the newest array of files
  s.files = ["lib/chronic", "lib/chronic/chronic.rb", "lib/chronic/grabber.rb", "lib/chronic/handlers.rb", "lib/chronic/ordinal.rb", "lib/chronic/pointer.rb", "lib/chronic/repeater.rb", "lib/chronic/repeaters", "lib/chronic/repeaters/repeater_day.rb", "lib/chronic/repeaters/repeater_day_name.rb", "lib/chronic/repeaters/repeater_day_portion.rb", "lib/chronic/repeaters/repeater_fortnight.rb", "lib/chronic/repeaters/repeater_hour.rb", "lib/chronic/repeaters/repeater_minute.rb", "lib/chronic/repeaters/repeater_month.rb", "lib/chronic/repeaters/repeater_month_name.rb", "lib/chronic/repeaters/repeater_season.rb", "lib/chronic/repeaters/repeater_season_name.rb", "lib/chronic/repeaters/repeater_second.rb", "lib/chronic/repeaters/repeater_time.rb", "lib/chronic/repeaters/repeater_week.rb", "lib/chronic/repeaters/repeater_weekday.rb", "lib/chronic/repeaters/repeater_weekend.rb", "lib/chronic/repeaters/repeater_year.rb", "lib/chronic/scalar.rb", "lib/chronic/separator.rb", "lib/chronic/time_zone.rb", "lib/chronic.rb", "lib/numerizer", "lib/numerizer/numerizer.rb", "test/suite.rb", "test/test_Chronic.rb", "test/test_Handler.rb", "test/test_Numerizer.rb", "test/test_parsing.rb", "test/test_RepeaterDayName.rb", "test/test_RepeaterFortnight.rb", "test/test_RepeaterHour.rb", "test/test_RepeaterMonth.rb", "test/test_RepeaterMonthName.rb", "test/test_RepeaterTime.rb", "test/test_RepeaterWeek.rb", "test/test_RepeaterWeekday.rb", "test/test_RepeaterWeekend.rb", "test/test_RepeaterYear.rb", "test/test_Span.rb", "test/test_Time.rb", "test/test_Token.rb"]
  s.require_path = "lib"
  s.autorequire = "chronic"
  s.test_file = "test/suite.rb"
  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
  s.rdoc_options << '--main' << 'README'
end