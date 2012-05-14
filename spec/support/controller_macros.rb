module ControllerMacros

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user
    end
  end

  def login_custom_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(:user, sign_in_count: 2)
      sign_in user
    end
  end

  def login_admin
    before(:each) do 
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin)
    end
  end
  
end