ActiveAdmin.register Company do
  
  index do |c|
    column :id
    column :name do |c|
      link_to c.name, edit_admin_company_path(c) 
    end
    column :address
    column :updated_at, sortable: true
    column "actions" do |c|    
      link_to 'editar', edit_admin_company_path(c) if c.updated_at < Date.today
    end
  end
  
  form do |f|
    f.inputs "Detalhes" do
      f.input :name
      f.input :address
      f.input :description
    end
    f.buttons
  end
  
  controller do
    
    def update
      @company = Company.find(params[:id])
      if @company.update_attributes(params[:company])
        redirect_to edit_admin_company_path(@company.id-1)
      else
        render :edit
      end
    end
  end
  
end
