require '../lib/tag_search'
require 'tempfile'
require 'test/unit'

class TestTagSearch < Test::Unit::TestCase
  include Kal::Exceptions

  def setup
    @search = TagSearch.new('kalyani', './fixture/')
    @result = { :kalyani => './kalyani.ogg' }
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

  def test_result
    assert_nothing_thrown { @search.result }
    assert_equal([], TagSearch.new('kalyani', '/tmp').result)

    assert_equal([@result[:kalyani]], @search.result)
  end
end
