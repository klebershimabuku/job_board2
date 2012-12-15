ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end 
end

# # encoding: utf-8
# ActiveAdmin::Dashboards.build do

#   pendings = Post.pendings
#   new_users = User.where("created_at >= ?", 1.week.ago).order('created_at DESC')
  
#   section "Novos usuários esta semana", priority: 1 do
#     h1 new_users.size
        
#     if new_users.size > 0 
#       table do
#         tr
#           th 'email'
#           th 'data de cadastro'
#         new_users.collect do |user|
#         tr  
#           td link_to user.email, admin_user_path(user)
#           td user.created_at.strftime('%d de %B de %Y')
#         end
#       end
#     end
#   end
  
#   section "Usuários com anúncios ativos", priority: 2 do
#     online_posts = Post.where("status = 'published'", :include => [:user])
    
#     table do
#       tr
#         th 'Email'
#         th 'Empresa'
#       online_posts.each do |post|
#         tr
#           td link_to post.user.email, admin_user_path(post.user)
#           td post.user.contact_info.title
#       end
#       tr
#         td hr
#         td hr
#       tr
#         td "Total:"
#         td online_posts.size
#     end
      
#   end

#   section "Total anúncios publicados", priority: 9 do
#     h1 Post.published.size
#     strong link_to "Ver relação de anúncios", admin_posts_path 
#   end
  
#   section "Anúncios pendentes", priority: 10, :if => pendings.size > 0 do
#     h1 pendings.size
#     if pendings.size > 0
#       ul do
#         pendings.collect do |post|
#           li link_to post.title, admin_post_path(post)
#         end
#       end
#     end          
    
#   end
  
#   section "Próximos anúncios à expirar" do
#     to_expire_soon = Post.where("created_at >= ?", 45.days.ago).order('created_at ASC')
#     table do
#       tr
#         td "Titulo"
#         td "Data expiração"
#       to_expire_soon.each do |post|
#       tr 
#         td link_to post.title, admin_post_path(post)
#         td (post.created_at + 60.days).strftime('%d de %B de%Y')
#       end
#     end
#   end
  
# end
