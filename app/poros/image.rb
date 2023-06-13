class Image
  attr_reader :image_small_url

  def initialize(data)
    @image_small_url = data[:urls][:small]
  end
end