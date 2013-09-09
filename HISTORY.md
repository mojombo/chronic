# 0.10.2 / 2013-09-09

* Fix 1.8.7 support (due to be dropped in 0.11.0)
* Bugfix for times with negative zones

# 0.10.1 / 2013-08-27

* Support `ActiveSupport::TimeZone` (#209, #208)

# 0.10.0 / 2013-08-25

* Chronic will parse subseconds correctly
  for all supported date/time formats (#195, #198 and #200)
* Support for date format: dd.mm.yyyy (#197)
* Option `:hours24` to parse as 24 hour clock (#201 and #202)
* `:guess` option allows to specify which part of Span to return.
  (accepted values `false`,`true`,`:begin`, `:middle`, `:end`)
* Replace `rcov` with `SimpleCov` for coverage generation
* Add more tests
* Various changes in codebase (#202 and #206)

# 0.9.1 / 2013-02-25

* Ensure Chronic strips periods from day portions (#173)
* Properly numerize "twelfth", "twentieth" etc. (#172, James McKinney)
* Ensure Chronic is compatible with Ruby 2.0.0 (#165, Ravil Bayramgalin)

# 0.9.0 / 2012-12-21

* Implement Chronic::Parser class and create an instance of this class
  instead of leaving all data in the class level of Chronic
* Various bug fixes
* Add support for excel date formats (#149, @jmondo)
* Added support for time expressions such as '10 till' or 'half
  past two' (#146, @chicagogrooves)
* Add support for RepeaterDayName, RepeaterMonthName,
  Ordinal/ScalarDay and Time (#153, @kareemk)

# 0.8.0 / 2012-09-16

* Support parsing "<ordinal> of this month" (#109)
* Support parsing ISO 8601 format (#115)
* Support parsing "on <day>" without a timestamp (#117)
* Fix time parsing regexp (#125)
* Support time when parsing dd-mm-yyy <time> (#126)
* Allow anchor handler to accept any separators (at, on) (#128)
* Support parsing EXIF date format (#112)
* Start using minitest for testing
* Ensure periods are interpreted as colons (#81).
* Support month/day and day/month parsing (#59).
* Support day(scalar)-month(name)-year(scalar) (#99).
* Handle text starting with 'a' or 'an' (#101, @steveburkett).
* Ensure post medium timestamps are correctly formatted (#89)

# 0.6.7 / 2012-01-31

* Handle day, month names with scalar day and year (Joe Fiorini)
* Ensure 31st parses correctly with day names (Joe Fiorini)

# 0.6.6 / 2011-11-23

* `Chronic.parse('thur')` no longer returns `nil` (@harold)

# 0.6.5 / 2011-11-04

* Fix bug when parsing ordinal repeaters (#73)
* Added handler support for day_name month_name (@imme5150)
* Fix bug when parsing strings prefixed with PM

# 0.6.4 / 2011-08-08

* Fixed bug where 'noon' was parsed as 00:00 rather than 12:00
  with :ambiguous_time_range => :none (Vladimir Chernis)
* Add support for handling '2009 May 22nd'
* Add the ability to handle scalar-day/repeater-month-name as well as ordinals

# 0.6.3 / 2011-08-01

* Ensure 'thu' is parsed as Thursday for 1.8.7 generic timestamp

# 0.6.2 / 2011-07-28

* Ensure specific endian handlers are prioritised over normal date handlers
* Recognize UTC as timezone and accept HH::MM timezone offset (Jason Dusek)

# 0.6.1 / 2011-07-21

* Ensure Handler definitions are executed in the correct order

# 0.6.0 / 2011-07-19

* Attempting to parse strings with days past the last day of a month will
  now return nil. ex: `Chronic.parse("30th February") #=> nil`
* All deprecated methods are marked for removal in Chronic 0.7.0
* Deprecated `Chronic.numericize_numbers` instead use
  `Chronic::Numerizer.numerize`
* Deprecated `Chronic::InvalidArgumentException` and instead use
  `ArgumentError`
* Deprecated `Time.construct` and use `Chronic.construct` in place of this
* Deprecated `Time#to_minidate`, instead use `Chronic::MiniDate.from_time(time)`
* Add support for handling generic timestamp for Ruby 1.9+

# 0.5.0 / 2011-07-01

* Replace commas with spaces instead of removing the char (Thomas Walpole)
* Added tests for RepeaterSeason
* Re-factored tests. Now rather than having a test_parsing method for testing
  all handlers, break them down independent of handler method. For example
  with handler `handle_sm_sd_sy` the subsequent test would be
  `test_handle_sm_sd_sy`
* Added support for parsing ordinal-dates/month-names/year, ie:
  `2nd of May 1995`
* Added support for parsing ordinal-dates and month names, ie:
  `22nd of February at 6:30pm`
* Fix `Time.construct` leap year checking. Instead use `Date.leap?(year)`

# 0.4.4 / 2011-06-12

* Fix RepeaterYear for fetching past year offsets when the current day is
  later than the last day of the same month in a past year (leap years) ie
  on 29th/feb (leap year) `last year` should (and now does) return 28th/feb
  instead of 1st/march
* Opt in for gem testing http://test.rubygems.org/

# 0.4.3 / 2011-06-08

* Fix issue with parsing 1:xxPM -- Ensure 1 is treated as ambiguous, not
  just >1

# 0.4.2 / 2011-06-07

* Fix MonthRepeater for fetching past month offsets when current day is
  later than the last day of a past month (ie on 29th of March when parsing
  `last month` Chronic would return March instead of February. Now Chronic
  returns the last day of the past month)

# 0.4.1 / 2011-06-05

* Fix MiniDate ranges for parsing seasons (Thomas Walpole)

# 0.4.0 / 2011-06-04

* Ensure context is being passed through grabbers. Now "Sunday at 2:18pm"
  with `:context => :past` will return the correct date
* Support parsing ordinal strings (eg first, twenty third => 1st, 23rd)
* Seasons now ignore DST and return 00 as an hour
* Support parsing 2 digit years and added `ambiguous_year_future_bias` option
* Support parsing 'thurs' for Thursday
* Fix pre_normalize() to remove periods before numerizing
* Fix RepeaterDays to not add an extra hour in future tense. This meant
  when parsing 'yesterday' after 11PM, Chronic would return today
* Discard any prefixed 0 for time strings when using post noon portion
* Gemspec updates for RubyGems deprecations
* Ensure 0:10 is treated like 00:10
* Ensure we load classes after setting Chronic class instance variables
  so we can debug initialization and do assignments at compile time
* Added a Tag.scan_for method for DRYing up some scanning code
* Move some classes into their own files for maintainability
* Numerizer.andition should be a private class method, make it so
* Namespaced Numerizer, Season and MiniDate (Sascha Teske)
* Support for Ruby 1.9 (Dave Lee, Aaron Hurley)
* Fix `:context => :past` where parsed date is in current month (Marc Hedlund)
* Fix undefined variable in RepeaterHour (Ryan Garver)
* Added support for parsing 'Fourty' as another mis-spelling (Lee Reilly)
* Added ordinal format support: ie 'February 14th, 2004' (Jeff Felchner)
* Fix dates when working with daylight saving times (Mike Mangino)

# 0.3.0 / 2010-10-22

* Fix numerizer number combination bug (27 Oct 2006 7:30pm works now)
* Allow numeric timezone offset (e.g -0500)
* Disregard commas (so as to not return nil)
* Fix parse of (am|pm|oclock) separation to handle "Ham sandwich" properly
* Handle 'on' e.g. 5pm on Monday
* Support seasons
* Support weekend/weekday
* Add endianness option
* Update version number in the module
* Fix/improve logic checks in Ordinal, and Scalar
* Parse 'a' or 'p' as 'am' and 'pm' google-calendar style
* Dates < 1 are not valid
* Fix bugs related to timezone offset
* Use RakeGem for build management
* Reformat README and HISTORY to use Markdown
* Global whitespace removal

# 0.2.3

* Fix 12am/12pm

# 0.2.2

* Add missing files (damn you manifest)

# 0.2.1

* Fix time overflow issue
* Implement "next" for minute repeater
* Generalize time dealiasing to dealias regardless of day portion and
  time position
* Add additional token match for cases like "friday evening at 7" and
  "tomorrow evening at 7"
* Add support for Time#to_s output format: "Mon Apr 02 17:00:00 PDT 2007"

# 0.2.0 2007-03-20

* Implement numerizer, allowing the use of number words (e.g. five weeks ago)

# 0.1.6 2006-01-15

* Add 'weekend' support

# 0.1.5 2006-12-20

* Fix 'aug 20' returning next year if current month is august
* Modify behavior of 'from now'
* Add support for seconds on times, and thus db timestamp format:
  "2006-12-20 18:04:23"
* Make Hoe compliant

# 0.1.4

* Remove verbose error checking code. oops. :-/

# 0.1.3

* improved regexes for word variations
* Fix a bug that caused "today at 3am" to return nil if current time is
  after 3am

# 0.1.2

* Remove Date dependency (now works on windows properly without fiddling)

# 0.1.1

* Run to_s on incoming object
* Fix loop loading of repeaters files (out of order on some machines)
* Fix find_within to use this instead of next (was breaking "today at 6pm")

# 0.1.0

* Initial release
