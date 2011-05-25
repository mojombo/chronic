require File.join(File.dirname(__FILE__), *%w[helper])

class ParseNumbersTest < Test::Unit::TestCase

  def test_straight_parsing
    strings = {
      'one' => 1,
      'five' => 5,
      'ten' => 10,
      'eleven' => 11,
      'twelve' => 12,
      'thirteen' => 13,
      'fourteen' => 14,
      'fifteen' => 15,
      'sixteen' => 16,
      'seventeen' => 17,
      'eighteen' => 18,
      'nineteen' => 19,
      'twenty' => 20,
      'twenty seven' => 27,
      'thirty-one' => 31,
      'thirty-seven' => 37,
      'thirty seven' => 37,
      'fifty nine' => 59,
      'forty two' => 42,
      'fourty two' => 42,
      # 'a hundred' => 100,
      'one hundred' => 100,
      'one hundred and fifty' => 150,
      # 'one fifty' => 150,
      'two-hundred' => 200,
      '5 hundred' => 500,
      'nine hundred and ninety nine' => 999,
      'one thousand' => 1000,
      'twelve hundred' => 1200,
      'one thousand two hundred' => 1_200,
      'seventeen thousand' => 17_000,
      'twentyone-thousand-four-hundred-and-seventy-three' => 21_473,
      'seventy four thousand and two' => 74_002,
      'ninety nine thousand nine hundred ninety nine' => 99_999,
      '100 thousand' => 100_000,
      'two hundred fifty thousand' => 250_000,
      'one million' => 1_000_000,
      'one million two hundred fifty thousand and seven' => 1_250_007,
      'one billion' => 1_000_000_000,
      'one billion and one' => 1_000_000_001}

    strings.each do |key, val|
      assert_equal val, Numerizer.numerize(key).to_i
    end
  end

  def test_edges
    assert_equal "27 Oct 2006 7:30am", Numerizer.numerize("27 Oct 2006 7:30am")
  end
end
