def full_title(title)
  title.empty? ? "ShigotoDoko" : "#{title} - ShigotoDoko"
end

def gravatar_for(user,options={})
  gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
  unless options[:size].nil?
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: options[:size])
  else
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end

def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Senha", with: user.password
  click_button 'Entrar'
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_info_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-info', text: message)
  end
end
