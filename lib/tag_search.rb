
class TagSearch
  attr_accessor :tags

  def initialize(tags)
    @tags = []
    @tags << tags
    @tags.flatten!
  end
end
