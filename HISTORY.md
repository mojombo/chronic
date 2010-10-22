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
