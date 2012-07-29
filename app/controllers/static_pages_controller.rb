class StaticPagesController < ApplicationController
  def help
    @message = Message.new
  end

  def about; end
end
