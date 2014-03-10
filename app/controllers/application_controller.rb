class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to authenticated_root_path, :alert => "Kamu tidak memiliki hak akses memasuki halaman ini"
  end

  protected
  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :primary_identification, :secondary_identification, :password, :remember_me) }
  end

  def json_request?
    request.format.json?
  end

  def html_request?
    request.format.html?
  end

  def js_request?
    request.format.js?
  end
end
