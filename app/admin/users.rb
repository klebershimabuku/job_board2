# encoding: utf-8
ActiveAdmin.register User do
  
  scope :publishers
  
  index do
    column :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column "Criado em", :created_at, :created_at, sortable: 'created_at' do |user|
      user.created_at.strftime('%d, %b de %Y')
    end
    column "Visto em", :last_sign_in_at, :last_sign_in_at, sortable: 'last_sign_in_at' do |user|
      user.last_sign_in_at.present? ? user.last_sign_in_at.strftime('%d, %b de %Y') : "Não visto."
    end
    column "Remover" do |user|
      link_to 'Remover', admin_user_path(user), method: 'delete', confirm: "Tem certeza que deseja excluir este usuário?"
    end
  end
  
  member_action :promote_to_announcer, method: 'get' do
    user = User.find(params[:id])
    user.promote_to_publisher!
    flash[:notice] = 'Usuário promovido à anunciante!'
    redirect_to admin_user_path(user)
  end
  
  action_item :only => :show do
    link_to 'Promover à Anunciante', promote_to_announcer_admin_user_path(user)
  end
  
  show do |user|
    name = user.name.present? ? user.name : "ainda não configurado."
    last_sign_in_at = user.last_sign_in_at.present? ? user.last_sign_in_at.strftime('%d, %m de %Y') : "não visto"
    created_at = user.created_at.strftime('%d, %b de %Y')
    
    attributes_table do
      row :name
      row :email
      row :created_at
      row :last_sign_in_at
    end

    if user.role == 'publisher'
      
      #
      # Contact Information
      #
      contact_info = ContactInfo.find_by_user_id(user)
      h2 'Informações de contato'
      
      if contact_info.present?
      
        table :id => 'generic' do
          tr
            th "Título"
            th "Descrição"
          tbody
          tr
            title       = contact_info.title.nil? ? "Não criado." : contact_info.title
            description = contact_info.description.nil? ? "Não criado." : contact_info.description
          
            td title
            td description
        end
        
      else
        
        h3 "ATENÇÃO: usuário impossibilitado de criar novos anúncios enquanto não definir informações para contato."
        br
      end
      
      # 
      # Show all posts
      #
      posts = Post.where('user_id = ?', user.id).order('created_at DESC')
      total = posts.size

      h2 pluralize(total, "anúncio publicado", "anúncios publicados") 
    
      table :id => 'generic' do
        tr
          th "Titulo"
          th "Data de criação"
          th "Data de publicação"
          th "Data de expiração"
          th "Status"
        tbody
        posts.each do |post|

        apply_label = case post.status
          when 'expired' then 'label-expired'
          when 'pending' then 'label-pending'
          else 'label-published'
        end

        tr
          td link_to post.title, admin_post_path(post)
          td post.created_at.present? ? post.created_at.strftime('%d, %b de %Y') : "N/D"
          td post.published_at.present? ? post.published_at.strftime('%d, %b de %Y') : "N/D"
          td post.expired_at.present? ? post.expired_at.strftime('%d, %b de %Y') : "N/D"
          td do
            span class: "label-status #{apply_label}" do
              post.status
            end
          end
        end        
      end # table
    end # role
  end

  # 
  # Forms
  #
  form do |f|
    f.inputs "Informações" do 
      f.input :name
      f.input :email
    end
    f.buttons
  end

end
