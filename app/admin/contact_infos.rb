ActiveAdmin.register ContactInfo do
  filter :user, :member_label => :email, collection: User.publishers
  
  form do |f|
    f.inputs "Information" do
      f.input :user, :member_label => :email, :collection => User.publishers
      f.input :title
      f.input :description, :input_html => { :rows => 5, :cols => 10 }
    end
    f.buttons
  end
  
  index do
    column :user_id do |contact_info|
      link_to User.find(contact_info.user_id).email, admin_user_path(contact_info.user_id)
    end
    column :title
    column :created_at
    column :updated_at
  end
  
  show do
    attributes_table do
      row :title
      row :description do |contact|
        simple_format contact.description
      end
      row :user_id
    end
  end
end
