# encoding: utf-8
ActiveAdmin::Dashboards.build do

  pendings = Post.pendings
  new_users = User.where("created_at >= ?", 1.week.ago).order('created_at DESC')
  
  section "Novos usuários esta semana", priority: 1 do
    h1 new_users.size
        
    if new_users.size > 0 
      table do
        tr
          th 'email'
          th 'data de cadastro'
        new_users.collect do |user|
        tr  
          td link_to user.email, admin_user_path(user)
          td user.created_at.strftime('%d de %B de %Y')
        end
      end
    end
  end
  
  section "Usuários com anúncios ativos", priority: 2 do
    online_posts = Post.where("status = 'published'", :include => [:user])
    
    table do
      tr
        th 'Email'
        th 'Empresa'
      online_posts.each do |post|
        tr
          td link_to post.user.email, admin_user_path(post.user)
          td post.user.contact_info.title
      end
      tr
        td hr
        td hr
      tr
        td "Total:"
        td online_posts.size
    end
      
  end

  section "Total anúncios publicados", priority: 9 do
    h1 Post.published.size
    strong link_to "Ver relação de anúncios", admin_posts_path 
  end
  
  section "Anúncios pendentes", priority: 10, :if => pendings.size > 0 do
    h1 pendings.size
    if pendings.size > 0
      ul do
        pendings.collect do |post|
          li link_to post.title, admin_post_path(post)
        end
      end
    end          
    
  end
  
  section "Próximos anúncios à expirar" do
    to_expire_soon = Post.where("created_at >= ?", 45.days.ago).order('created_at ASC')
    table do
      tr
        td "Titulo"
        td "Data expiração"
      to_expire_soon.each do |post|
      tr 
        td link_to post.title, admin_post_path(post)
        td (post.created_at + 60.days).strftime('%d de %B de%Y')
      end
    end
  end
  
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
