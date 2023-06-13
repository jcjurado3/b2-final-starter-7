require "httparty"
require "json"

class HolidayService

  def holiday_info
    holidays_data = service.holiday_url
    holidays_data.map { |holiday_data| Holiday.new(holiday_data) }
  end

  def service
    NagerdateService.new
  end
end