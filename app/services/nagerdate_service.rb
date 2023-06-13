require "httparty"
require "json"

class NagerdateService


  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def holiday_url
    get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end
end