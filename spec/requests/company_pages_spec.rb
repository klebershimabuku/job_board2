# encoding: utf-8
require 'spec_helper'

describe "CompanyPages" do
  
  subject { page }

  before(:each) do
    ['Aichi-ken', 'Shizuoka-ken', 'Gunma-ken'].map { |p| FactoryGirl.create(:prefecture, name: p) }
  end

  describe 'index page' do 
    
    before { visit '/empresas/provincias' }

    it { should have_selector('h1', text: 'Empreiteiras no Japão') }

    it 'lists all prefectures' do 
      Prefecture.all.each do |prefecture|
        should have_selector('li', text: prefecture.name)
        should have_link(prefecture.name, href: list_companies_path(prefecture.name.downcase))
      end 
    end
  end

  describe 'new page' do 

    describe 'as a regular user' do 
      before { visit new_company_path }
      it { should have_error_message('Acesso Negado') }
    end

    describe 'as admin' do 
      before do
        @user = FactoryGirl.create(:admin)
        valid_signin @user
        @company = FactoryGirl.create(:company)
        visit new_company_path
      end

      it { should have_selector('title', text: 'Cadastro de empresa') }

      context 'with valid information and 1 prefecture' do
        before do
          fill_in 'Nome da empresa',       with: @company.name
          fill_in 'Endereço',    with: @company.address
          fill_in 'Descrição',with: @company.description
          find(:css, "#company_prefecture_ids_[value='" + Prefecture.first.id.to_s + "']").set(true)
          click_button 'Cadastrar'
        end
        it { should have_success_message('Empresa cadastrada com sucesso.') }
        it_behaves_like 'a company page'
      end

      context 'with invalid information' do
        before do
          fill_in 'Nome da empresa',  with: ""
          fill_in 'Endereço',         with: ""
          fill_in 'Descrição',        with: ""
          find(:css, "#company_prefecture_ids_[value='" + Prefecture.first.id.to_s + "']").set(true)
        end
        it "should NOT create a new company" do
          expect { click_button 'Cadastrar' }.to_not change(Company, :count).by(1)
        end

        context "if validation fails, returns a message" do
          before { click_button 'Cadastrar' }
          it { should have_content("erro") }
        end
      end
    end
  end

  describe 'edit page' do

    describe 'as a regular user' do
      before do
        @prefecture = FactoryGirl.create(:prefecture, name: 'Saitama-ken')
        @company = FactoryGirl.create(:company, :prefectures => [@prefecture])
        visit edit_company_path(@company)
      end
      it { should have_error_message('Acesso Negado')}
    end

    describe 'as admin' do 

      before do
        @prefecture = FactoryGirl.create(:prefecture, name: 'Saitama-ken')
        @company = FactoryGirl.create(:company, :prefectures => [@prefecture])

        @user = FactoryGirl.create(:admin)
        valid_signin @user

        visit edit_company_path(@company)
      end

      it { should have_selector('title', text: "Edição de dados, #{@company.name}") }

      context 'with valid information and 1 prefecture' do
        before do
          fill_in 'Nome da empresa',       with: 'Second Company'
          fill_in 'Endereço',    with: @company[:address]
          fill_in 'Descrição',with: @company[:description]
          find(:css, "#company_prefecture_ids_[value='" + Prefecture.first.id.to_s + "']").set(true)
          click_button 'Salvar'
        end
        it { should have_success_message('Dados da empresa atualizados com sucesso.') }
        it { should have_selector('title', text: 'Second Company') }
        it { should have_selector('h1', text: 'Second Company') }
        it { should have_content(@company[:address]) }
        it { should have_content(@company[:description]) }
      end

      context 'with invalid information' do
        before do
          fill_in 'Nome da empresa',  with: ""
          fill_in 'Endereço',         with: ""
          fill_in 'Descrição',        with: ""
          find(:css, "#company_prefecture_ids_[value='" + Prefecture.first.id.to_s + "']").set(true)
        end
        it "should NOT update the record" do
          expect { click_button 'Salvar' }.to_not change(Company, :count).by(1)
        end

        context "if validation fails, returns a message" do
          before { click_button 'Salvar' }
          it { should have_content("erro") }
        end
      end
    end
  end

  describe 'list companies page' do

    context 'when there are one or more companies' do 
      before do
        @prefecture = FactoryGirl.create(:prefecture, name: 'Saitama-ken')
        @company = FactoryGirl.create(:company, :prefectures => [@prefecture])
        visit '/empresas/provincias/saitama-ken'
      end
      it { should have_selector('title', text: 'Empreiteiras em Saitama-ken') }
      it 'should list all companies in Saitama-ken' do 
        Prefecture.find_by_name('Saitama-ken').companies.each do |company|
          should have_selector('li', text: company.name)
          should have_link(company.name, href: company_path(company) )
        end
      end
    end
    context 'when there are no company' do 
      before do
        @prefecture = FactoryGirl.create(:prefecture, name: 'Saitama-ken')
        visit '/empresas/provincias/saitama-ken'
      end
      it { should have_selector('title', text: 'Empreiteiras em Saitama-ken') }
      it { should have_content('Não há empreiteiras cadastradas ainda.')}
    end
  end

  describe 'show page' do
    before do
      @prefecture = FactoryGirl.create(:prefecture, name: 'Saitama-ken')
      @company = FactoryGirl.create(:company, :prefectures => [@prefecture])
      visit company_path(@company)
    end
    it_behaves_like 'a company page'
  end
end
