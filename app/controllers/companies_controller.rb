class CompaniesController < ApplicationController
  load_and_authorize_resource only: [:new, :edit, :destroy]

  def prefectures
    @prefectures = Prefecture.all
  end

  def list
    @companies = Prefecture.find_by_name(params[:name].capitalize).companies
  end

  def index
    redirect_to prefectures_companies_path
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:success] = 'Empresa cadastrada com sucesso.'
      redirect_to @company 
    else
      render :new
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash[:success] = 'Dados da empresa atualizados com sucesso.'
      redirect_to @company
    else
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    flash[:success] = "Empresa removida com sucesso."
    redirect_to companies_path
  end
end
