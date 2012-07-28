class ContactController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    
    if @message.valid?
      Notifier.new_message(@message).deliver
      redirect_to(root_path, :notice => "Mensagem enviada com sucesso")
    else
      flash.now.alert = "Por favor preencha todos os campos."
      render :new
    end
  end

end