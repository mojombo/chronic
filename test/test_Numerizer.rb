require 'test/unit'
require 'chronic'

class ParseNumbersTest < Test::Unit::TestCase

  def test_straight_parsing
    strings = { 1 => 'one',
               5 => 'five',
               10 => 'ten',
               11 => 'eleven',
               12 => 'twelve',
               13 => 'thirteen',
               14 => 'fourteen',
               15 => 'fifteen',
               16 => 'sixteen',
               17 => 'seventeen',
               18 => 'eighteen',
               19 => 'nineteen',
               20 => 'twenty',
               27 => 'twenty seven',
               31 => 'thirty-one',
               59 => 'fifty nine',
               100 => 'a hundred',
               100 => 'one hundred',
               150 => 'one hundred and fifty',
            #   150 => 'one fifty',
               200 => 'two-hundred',
               500 => '5 hundred',
               999 => 'nine hundred and ninety nine',
               1_000 => 'one thousand',
               1_200 => 'twelve hundred',
               1_200 => 'one thousand two hundred',
               17_000 => 'seventeen thousand',
               21_473 => 'twentyone-thousand-four-hundred-and-seventy-three',
               74_002 => 'seventy four thousand and two',
               99_999 => 'ninety nine thousand nine hundred ninety nine',
               100_000 => '100 thousand',
               250_000 => 'two hundred fifty thousand',
               1_000_000 => 'one million',
               1_250_007 => 'one million two hundred fifty thousand and seven',
               1_000_000_000 => 'one billion',
               1_000_000_001 => 'one billion and one' }
               
    strings.keys.sort.each do |key|
      assert_equal key, Numerizer.numerize(strings[key]).to_i
    end
  end
end