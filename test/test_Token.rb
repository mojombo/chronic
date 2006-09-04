require 'chronic'
require 'test/unit'

class TestToken < Test::Unit::TestCase
  
  def setup
    # Wed Aug 16 14:00:00 UTC 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
  end
  
  def test_token
    token = Chronic::Token.new('foo')
    assert_equal 0, token.tags.size
    assert !token.tagged?
    token.tag("mytag")
    assert_equal 1, token.tags.size
    assert token.tagged?
    assert_equal String, token.get_tag(String).class
    token.tag(5)
    assert_equal 2, token.tags.size
    token.untag(String)
    assert_equal 1, token.tags.size
    assert_equal 'foo', token.word
  end
  
end