# encoding: utf-8
class Notifier < ActionMailer::Base
  default from: "no-reply@shigotodoko.com"

  def new_post_submitted(post, destination)
    @post = post
    mail(to: destination, subject: "Novo anúncio enviado: #{@post.title}")
  end

end
