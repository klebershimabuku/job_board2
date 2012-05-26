class PostObserver < ActiveRecord::Observer

  def after_create(post)
    Notifier.new_post_submitted(post, 'admin@shigotodoko.com').deliver
  end
  
end
