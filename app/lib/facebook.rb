module Facebook

  def self.publish(message, link, description)
    page = FbGraph::User.me(APP_CONFIG['facebook']['access_token']).accounts.first
    page.feed!(message: message, link: link, description: description)
  end

end