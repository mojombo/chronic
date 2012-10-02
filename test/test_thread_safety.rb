require 'helper'
require 'thread'

class TestThreadSafety < TestCase

  # Prior to Oct 2012, Chronic.parse was not thread-safe when the :now option was used
  # This test ensures that running Chronic.parse simultaneously in many threads,
  #   with different :now parameters on each thread, yields correct results
  # NOTE: Even if Chronic is *NOT* thread-safe, this test will still pass when run on a VM
  #   with a global interpreter lock (I'm looking at you, MRI)

  # As of this writing, JRuby does not support Date#to_time and Time#to_date, so I avoid using them
  
  def test_parsing_on_multiple_threads
    dates   = (1..100).map { |n| Date.today + n }
    results = [] # assertions don't work when not on the main thread! so we accumulate results first
    mutex   = Mutex.new # to protect "results" array
    latch   = CountdownLatch.new(dates.size) # to make all threads start parsing at the same time
  
    n = -1 # #with_index is more elegant, but doesn't work on Ruby 1.8
    threads = dates.map do |date|
      n += 1
      Thread.new(n) do |i|
        latch.count_down
        result = Chronic.parse('today', :now => Time.local(date.year,date.mon,date.day))
        mutex.synchronize { results[i] = result }
      end
    end
    threads.each { |t| t.join } # wait for all threads to finish

    results.zip(dates).each do |result,date|
      assert_equal date.day, result.day
    end
  end
end

class CountdownLatch
  def initialize(count)
    @counter = count
    @queue   = ConditionVariable.new
    @mutex   = Mutex.new
  end

  def count_down
    @mutex.synchronize do
      @counter =- 1
      if @counter <= 0
        @queue.broadcast
      else
        @queue.wait(@mutex)
      end
    end
  end
end
