class WeathersController < ApplicationController


  def index
    if params[:latitude].present? && params[:longitude].present?
      unless valid_coordinates?(params[:latitude], params[:longitude])
        flash[:alert] = "Latitude e longitude inválidas."
        return
      end

      begin
        @weather = WeatherService.get_weather_by_lat_lng(params[:latitude], params[:longitude])
        puts "Dados meteorológicos retornados:", @weather.inspect # Log para depuração
      rescue => e
        flash[:alert] = "Erro ao obter informações meteorológicas: #{e.message}"
        @weather = nil
      end
    else
      flash[:alert] = "Por favor, informe a latitude e longitude."
    end

    if request.xhr?
      if @weather
        render json: { weather: @weather }, status: :ok
      else
        render json: { error: flash[:alert] || "Não foi possível obter informações meteorológicas." }, status: :unprocessable_entity
      end
    else
      if @weather.nil?
        flash[:alert] ||= "Não foi possível obter informações meteorológicas."
      end
    end
  end

  private

  def valid_coordinates?(lat, lng)
    lat.to_f.between?(-90, 90) && lng.to_f.between?(-180, 180)
  end
end
