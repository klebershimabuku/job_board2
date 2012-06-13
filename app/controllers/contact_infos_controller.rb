# encoding: utf-8
class ContactInfosController < ApplicationController
  load_and_authorize_resource

  def new
    @contact_info = ContactInfo.new
  end

  def create
    @contact_info = current_user.build_contact_info(params[:contact_info])
    if @contact_info.save
      flash[:success] = "Informação de contato salva com sucesso."
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def edit
    @contact_info = ContactInfo.find(params[:id])
  end

  def update
    @contact_info = ContactInfo.find(params[:id])
    if @contact_info.update_attributes(params[:contact_info])
      flash[:success] = "Informação de contato atualizada com sucesso."
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    @contact_info = ContactInfo.find(params[:id]).destroy
    flash[:success] = "Informações de contato removidas com sucesso."
    redirect_to user_path(current_user)
  end

end