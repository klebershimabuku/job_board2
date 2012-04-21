module ApplicationHelper

  def full_title(title)
    title.empty? ? "ShigotoDoko" : "#{title} - ShigotoDoko"
  end

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end
  
end
