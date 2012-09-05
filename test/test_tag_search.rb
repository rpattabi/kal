require '../lib/tag_search'
require 'tempfile'
require 'test/unit'

class TestTagSearch < Test::Unit::TestCase
  include Kal::Exceptions

  def setup
    @root_path = './fixture/'
    @search = TagSearch.new('kalyani', @root_path)
    @result = { :kalyani => "#{@root_path}kalyani.ogg", 
                :KaLyani => "#{@root_path}kalyani.ogg" }
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

  def test_results
    assert_nothing_thrown { @search.results }
    assert_equal([], TagSearch.new('kalyani', '/tmp').results)

    assert_equal([@result[:kalyani]], @search.results)
    assert_equal([@result[:KaLyani]], @search.results)
    assert_equal([], TagSearch.new('kani', @root_path).results)
  end
end
