require '../lib/tag_search'
require 'tempfile'
require 'test/unit'

class TestTagSearch < Test::Unit::TestCase
  include Kal::Exceptions

  def setup

  end

  def test_initialize
    assert_raise(ArgumentError) { TagSearch.new() }
    assert_raise(BadTagError) { TagSearch.new('') }
    assert_raise(BadTagError) { TagSearch.new('  ') }
    assert_raise(BadTagError) { TagSearch.new([]) }
    assert_raise(BadTagError) { TagSearch.new(['', ' ']) }

    search = TagSearch.new('kalyani')
    assert_not_nil(search)
    assert_equal(['kalyani'], search.tags)
    assert_equal('.', search.root)
  end

  def test_tags
    search = TagSearch.new('thyagaraja')
    assert_equal(['thyagaraja'], search.tags)

    search = TagSearch.new(['anu', 'ragu'])
    assert_equal(['anu', 'ragu'], search.tags)

    search = TagSearch.new(['anu', '', 'ragu'])
    assert_equal(['anu', 'ragu'], search.tags)

    search = TagSearch.new(['anu', 'ragu', '  '])
    assert_equal(['anu', 'ragu'], search.tags)
  end

  def test_root
    search = TagSearch.new('ragu')
    assert_equal('.', search.root)

    search = TagSearch.new('ragu', '/tmp')
    assert_equal('/tmp', search.root)

    assert_raise(BadRootPathError) { search = TagSearch.new('ragu', '/tmp/dingdong/') }

    Tempfile.open('dingdong') do |f|
      assert_raise(BadRootPathError) { search = TagSearch.new('ragu', f.path) }
    end
  end
end
