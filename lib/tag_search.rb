
module Kal
  module Exceptions
    class BadTagError < Exception
    end

    class BadRootPathError < Exception
    end
  end
end

class TagSearch
  include Kal::Exceptions

  attr_accessor :tags
  attr_reader :root

  def initialize(tags, root_path='.')
    @tags = process_tags(tags)
    @root = process_root(root_path)
  end

  private

  def process_tags(tags)
    tmp_tags = []
    tmp_tags << tags
    tmp_tags.flatten!

    processed_tags = tmp_tags.collect { |t| t.strip unless t.strip.empty? }
    processed_tags.compact!
    raise BadTagError if processed_tags.empty?

    processed_tags
  end

  def process_root(root_path)
    raise BadRootPathError unless File.exists?(root_path)
    raise BadRootPathError unless File.directory?(root_path)

    root_path
  end
end



