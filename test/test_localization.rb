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
    assert !Chronic.has_locale(:other), ':other locale should NOT be available'
    Chronic.locale = :other
    other = {}
    Chronic.add_locale :other, other
    assert Chronic.has_locale(:other), ':other locale should be available'
  end

  def test_loads_locale
    assert_includes Chronic.translate([:numerizer, :direct_nums]), ['eleven', '11']
  end

  def test_fallsback_if_translation_not_found
    Chronic.locale = :not_found
    other = {}
    Chronic.add_locale :not_found, other
    assert_includes Chronic.translate([:numerizer, :direct_nums]), ['eleven', '11']
  end
end
