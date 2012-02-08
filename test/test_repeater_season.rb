require 'helper'

class TestRepeaterSeason < TestCase

  def setup
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end

  def test_next_future
    seasons = Chronic::RepeaterSeason.new(:season)
    seasons.start = @now

    next_season = seasons.next(:future)
    assert_equal Time.local(2006, 9, 23), next_season.begin
    assert_equal Time.local(2006, 12, 21), next_season.end
  end

  def test_next_past
    seasons = Chronic::RepeaterSeason.new(:season)
    seasons.start = @now

    last_season = seasons.next(:past)
    assert_equal Time.local(2006, 3, 20), last_season.begin
    assert_equal Time.local(2006, 6, 20), last_season.end
  end

  def test_this
    seasons = Chronic::RepeaterSeason.new(:season)
    seasons.start = @now

    this_season = seasons.this(:future)
    assert_equal Time.local(2006, 8, 17), this_season.begin
    assert_equal Time.local(2006, 9, 22), this_season.end

    this_season = seasons.this(:past)
    assert_equal Time.local(2006, 6, 21), this_season.begin
    assert_equal Time.local(2006, 8, 16), this_season.end
  end

end
