# encoding: utf-8
ActiveAdmin.register Post do
  
  scope :publisheds
  scope :pendings
  scope :expireds
  
  filter :user, member_label: 'email', collection: User.publishers
  filter :title
  filter :description
  filter :location
  filter :created_at
  filter :updated_at
  filter :published_at
  filter :expired_at
  filter :tags
  filter :views
  filter :status
  
  index do
    column :title do |post|
      div do
        link_to post.title, admin_post_path(post)
      end
    end
    
    column "Data de criação", :created_at, sortable: 'created_at' do |post|
      post.created_at.strftime('%d, %b de %Y')
    end
    
    column "TAGS" do |post|
      post.tags
    end

    if params[:scope] == 'expireds'
      column "Data de expiração", :expired_at, sortable: 'expired_at' do |post|
        post.expired_at.strftime('%d, %b de %Y')
      end
    end

    if params[:scope] == 'publisheds'
      column "Data de publicação", :published_at, sortable: 'published_at' do |post|
        post.published_at.strftime('%d, %b de %Y')
      end
    end
    
    column :status do |post|
      
      apply_label = case post.status
        when 'expired' then 'label-expired'
        when 'pending' then 'label-pending'
        else 'label-published'
      end
      
      span class: "label-status #{apply_label}" do
        post.status
      end
    end
  end
  
  #
  # show
  #
  show do
    h1 post.title
    h3 post.location
    hr
    br
    div do
      h4 simple_format post.description
    end
    h3 link_to "Anunciante: #{post.user.email}", admin_user_path(post.user_id)
    hr
    h3 "TAGS: #{post.tags}"
    hr
    
    apply_label = case post.status
      when 'expired' then 'label-expired'
      when 'pending' then 'label-pending'
      else 'label-published'
    end
    
    h4 "STATUS: " do
      span class: "label-status #{apply_label}" do
        post.status
      end
    end
  end

  # 
  # Forms
  #
  form do |f|
    f.inputs "Informações" do 
      f.input :title
      f.input :location
      f.input :description
    end
    f.buttons
  end
    
  member_action :publish, method: 'get' do
    post = Post.find(params[:id])
    post.publish!
    redirect_to admin_post_path(post), notice: 'Anúncio publicado com sucesso!'
  end

  member_action :expire, method: 'get' do
    post = Post.find(params[:id])
    post.expire!
    redirect_to admin_post_path(post), notice: 'Anúncio expirado com sucesso!'
  end

  action_item :only => :show do
    if post.status == 'pending' 
      link_to 'Publicar', publish_admin_post_path(post)
    elsif post.status == 'published'
      link_to 'Expirar', expire_admin_post_path(post)
    else
    end
  end
    
end
