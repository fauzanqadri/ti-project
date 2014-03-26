class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!
  before_filter :checking_setting!, unless: :devise_controller?
  before_filter :checking_assessment!, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to authenticated_root_path, :alert => "Kamu tidak memiliki hak akses memasuki halaman ini"
  end

  rescue_from Exceptions::SettingsRequired do |exception|
    respond_to do |format|
      flash[:alert] = "Evaluasi konfigurasi jurusan kamu #{view_context.link_to("di sini", settings_path)} untuk menggunakan sistem lebih lanjut".html_safe
      format.html {redirect_to authenticated_root_path}
      format.js { render js: 'alert("Konfigurasi pada jurusan kamu perlu dievaluasi, minta ketua prodi untuk mengevaluasi");'}
      format.json {render json: "Konfigurasi pada jurusan kamu perlu dievaluasi, minta ketua prodi untuk mengevaluasi"}
    end
  end

  rescue_from Exceptions::AssessmentBlank do |exception|
    respond_to do |format|
      flash[:alert] = "Evaluasi aspek penilaian Seminar / Sidang pada jurusan kamu #{view_context.link_to("di sini", assessments_path)} untuk menggunakan sistem lebih lanjut".html_safe
      format.html {redirect_to authenticated_root_path}
      format.js { render js: 'alert("Aspek penilaian Seminar / Sidang pada jurusan kamu perlu dievaluasi, minta ketua prodi untuk mengevaluasi");'}
      format.json {render json: "Aspek penilaian Seminar / Sidang pada jurusan kamu perlu dievaluasi, minta ketua prodi untuk mengevaluasi"}
    end
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

  def checking_setting!
    return true unless user_signed_in?
    return true if current_user.userable_type == "Staff"
    setting = current_user.userable.department.setting
    raise Exceptions::SettingsRequired.new if (setting.department_director.nil? || setting.department_director.blank?) || (setting.department_secretary.nil? || setting.department_secretary.blank?)
  end

  def checking_assessment!
    return true unless user_signed_in?
    return true if current_user.userable_type == "Staff"
    assessments = current_user.userable.department.assessments
    raise Exceptions::AssessmentBlank.new if assessments.blank?
  end
end
