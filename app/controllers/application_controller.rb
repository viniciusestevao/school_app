class ApplicationController < ActionController::Base
  include Pagy::Backend
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    extra_attrs = [
      :name, :code, :birthday_at, :phone_number, :gender,
      :address, :number, :neighborhood, :city, :state, :postal_code, :complement,
      :role
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_attrs + [:status])
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Você não tem permissão para acessar esta página."
    end
  end
end
