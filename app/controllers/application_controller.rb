class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: "Você não está autorizado a acessar esta página."
  end
end
