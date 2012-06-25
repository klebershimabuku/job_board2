# encoding: utf-8
class AgenciesController < ApplicationController

  def index
    @prefectures = Prefecture.all
  end

  def list
    begin
      @prefecture = Agency.new(params[:prefecture_name])
      @offices = @prefecture.find_offices
    rescue CustomExceptions::InvalidPrefecture
      flash[:error] = 'Não foi possível encontrar a província solicitada.'
      redirect_to hello_work_agencies_path
    end
  end
end
