class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  # handle unauthorized access
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => 'Acesso Negado'
  end

  # redirect registered users to a profile page
  def after_sign_in_path_for(resource)
    resource.role == 'admin' ? admin_dashboard_path : user_path(resource)
  end
  
  def authenticate_admin_user!
    raise SecurityError unless current_user.try(:role) == 'admin'
  end
  
  rescue_from SecurityError do |exception|
    redirect_to root_path
  end
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
