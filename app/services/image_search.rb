class ImageSearch

  def image_search(image_name)
    Image.new(service.image_url(image_name))
  end

  def service
    UnsplashService.new
  end
end