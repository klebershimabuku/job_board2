module UsersHelper
  def gravatar_for(user,options={})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
    unless options[:size].nil?
      image_tag(gravatar_url, alt: user.name, class: "gravatar", size: options[:size])
    else
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end
end
