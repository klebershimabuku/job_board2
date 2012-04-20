class RegistrationsController <  Devise::RegistrationsController

  protected

  # redirect new users to a successful page
  def after_sign_up_path_for(resource)
    user_registration_successfull_path
  end

end
