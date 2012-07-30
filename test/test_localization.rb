require 'helper'

class TestLocalization < TestCase

  def setup
    @locale_before = Chronic.locale
    @hashes_before = Chronic.locale_hashes
  end

  def teardown
    Chronic.locale = @locale_before
    Chronic.locale_hashes = @hashes_before
  end

  def test_default_locale_is_english
    assert_equal :en, Chronic.locale
  end

  def test_nonexistent_locale
    assert_raises(ArgumentError) do
      Chronic.locale = :nonexistent
      Chronic.parse('some string')
    end
  end

  def test_add_locale
    Chronic.locale = :other
    other = {}
    Chronic.add_locale :other, other
    assert_equal other, Chronic.locale_hash
  end

  def test_loads_locale
    assert Chronic.locale_hash[:numerizer][:direct_nums].include?(['eleven', '11'])
  end
end
