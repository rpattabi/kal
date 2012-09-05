require './lib/tag_search'
require 'test/unit'

class TestTagSearch < Test::Unit::TestCase
  def setup

  end

  def test_initialize
    assert_raise(ArgumentError) { TagSearch.new() }

    search = TagSearch.new('kalyani')
    assert_not_nil(search)
    assert_equal(['kalyani'], search.tags)
  end

  def test_tags
    search = TagSearch.new('thyagaraja')
    assert_equal(['thyagaraja'], search.tags)

    search = TagSearch.new(['anu', 'ragu'])
    assert_equal(['anu', 'ragu'], search.tags)
  end
end
