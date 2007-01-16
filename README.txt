Chronic
	http://chronic.rubyforge.org/
	by Tom Preston-Werner

== DESCRIPTION:

Chronic is a natural language date/time parser written in pure Ruby. See below for the wide variety of formats Chronic will parse.

== INSTALLATION:

Chronic can be installed via RubyGems:

  $ sudo gem install chronic

== USAGE:

You can parse strings containing a natural language date using the Chronic.parse method.

  require 'rubygems'
  require 'chronic'

  Time.now   #=> Sun Aug 27 23:18:25 PDT 2006

  #---

  Chronic.parse('tomorrow')       
    #=> Mon Aug 28 12:00:00 PDT 2006

  Chronic.parse('monday', :context => :past)
    #=> Mon Aug 21 12:00:00 PDT 2006

  Chronic.parse('this tuesday 5:00')
    #=> Tue Aug 29 17:00:00 PDT 2006

  Chronic.parse('this tuesday 5:00', :ambiguous_time_range => :none)
    #=> Tue Aug 29 05:00:00 PDT 2006

  Chronic.parse('may 27th', :now => Time.local(2000, 1, 1))
    #=> Sat May 27 12:00:00 PDT 2000

  Chronic.parse('may 27th', :guess => false)
    #=> Sun May 27 00:00:00 PDT 2007..Mon May 28 00:00:00 PDT 2007

See Chronic.parse for detailed usage instructions.

== EXAMPLES:

Chronic can parse a huge variety of date and time formats. Following is a small sample of strings that will be properly parsed. Parsing is case insensitive and will handle common abbreviations and misspellings.

Simple

  thursday
  november
  summer
  friday 13:00
  mon 2:35
  4pm
  6 in the morning
  friday 1pm
  sat 7 in the evening
  yesterday
  today
  tomorrow
  this tuesday
  next month
  last winter
  this morning
  last night
  this second
  yesterday at 4:00
  last friday at 20:00
  last week tuesday
  tomorrow at 6:45pm
  afternoon yesterday
  thursday last week

Complex

  3 years ago
  5 months before now
  7 hours ago
  7 days from now
  1 week hence
  in 3 hours
  1 year ago tomorrow
  3 months ago saturday at 5:00 pm
  7 hours before tomorrow at noon
  3rd wednesday in november
  3rd month next year
  3rd thursday this september
  4th day last week

Specific Dates

  January 5
  dec 25
  may 27th
  October 2006
  oct 06
  jan 3 2010
  february 14, 2004
  3 jan 2000
  17 april 85
  5/27/1979
  27/5/1979
  05/06
  1979-05-27
  Friday
  5
  4:00
  17:00
  0800

Specific Times (many of the above with an added time)

  January 5 at 7pm
  1979-05-27 05:00:00
  etc

== LIMITATIONS:
  
Chronic uses Ruby's built in Time class for all time storage and computation. Because of this, only times that the Time class can handle will be properly parsed. Parsing for times outside of this range will simply return nil. Support for a wider range of times is planned for a future release.

Time zones other than the local one are not currently supported. Support for other time zones is planned for a future release.

== LICENSE:

(The MIT License)

Copyright (c) 2006 Ryan Davis, Zen Spider Software

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
