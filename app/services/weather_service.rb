class WeatherService
  include HTTParty
  base_uri 'https://api.hgbrasil.com'

  def self.get_weather_by_lat_lng(lat, lng)
    begin
      response = get("/weather", query: { key: '911f410c', lat: lat, lon: lng })
      puts "Resposta da API (Lat/Lng):", response.inspect # Log para depuração
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
