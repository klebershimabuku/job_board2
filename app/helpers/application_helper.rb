require 'rdiscount'

module ApplicationHelper
  
  def m(string)
    RDiscount.new(string).to_html.html_safe
  end

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

  def admin?
    current_user.role == 'admin'
  end
  
  def author_age
    birthday = Date.strptime("{ 1982, 9, 11 }", "{ %Y, %m, %d }")
    Date.today.year - birthday.year
  end

  def special_flash(value)
    f = '--'
    if value.include?(f)
      nv = value.split(f)
      content_tag(:strong, nv[0]) + nv[1]
    else
      value
    end
  end
end
