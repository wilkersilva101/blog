# app/services/weather_service.rb
require 'httparty'

class WeatherService
  include HTTParty
  base_uri 'https://api.hgbrasil.com/weather'

  def self.get_weather(city_name)
    begin
      response = get("/locale", query: { key: '911f410c', city_name: city_name })
      handle_response(response)
    rescue StandardError => e
      log_error(e)
      nil
    end
  end

  def self.get_weather_by_lat_lng(lat, lng)
    begin
      response = get("/geo", query: { key: '911f410c', lat: lat, lon: lng })
      handle_response(response)
    rescue StandardError => e
      log_error(e)
      nil
    end
  end

  private

  def self.handle_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      log_error("Erro na requisição: #{response.code} - #{response.body}")
      nil
    end
  end

  def self.log_error(error)
    Rails.logger.error("Erro no WeatherService: #{error.message}")
  end
end
