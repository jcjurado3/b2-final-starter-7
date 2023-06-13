class UnsplashService

  def image_url(image)
    get_url("https://api.unsplash.com/photos/random?client_id=5LdyjwQLiAuLrMg_CQSXRjgo3hk9DvIE40lLpY4_nvA&query=#{image}")
  end


  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end