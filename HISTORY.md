# 0.4.4

* Fix RepeaterYear for fetching past year offsets when the current day is
  later than the last day of the same month in a past year (leap years) ie
  on 29th/feb (leap year) `last year` should (and now does) return 28th/feb
  instead of 1st/march

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
