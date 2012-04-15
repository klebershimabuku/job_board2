module ApplicationHelper

  def full_title(title)
    title.empty? ? "ShigotoDoko" : "#{title} - ShigotoDoko"
  end

end
