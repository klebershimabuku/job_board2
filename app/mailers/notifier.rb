# encoding: utf-8
class Notifier < ActionMailer::Base
  default from: "no-reply@shigotodoko.com"
  default to: "admin@shigotodoko.com"

  def new_post_submitted(post)
    @post = post
    mail(subject: "Anúncio enviado: #{@post.title}")
  end
  
  def new_message(message)
    @message = message
    mail(subject: "Mensagem de contato: #{@message.subject}")
  end

end
