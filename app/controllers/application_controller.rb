class ApplicationController < ActionController::Base
  protect_from_forgery

  # handle unauthorized access
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => 'Acesso Negado'
  end

  # redirect registered users to a profile page
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

end
