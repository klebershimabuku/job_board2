class ApplicationController < ActionController::Base
  protect_from_forgery

  # redirect registered users to a profile page
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

end
