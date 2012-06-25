#encoding: utf-8
require 'spec_helper'

describe 'Agency Index page' do 
  subject { page }

  before do
    ['Aichi-ken','Chiba-ken'].each { |f| FactoryGirl.create(:prefecture, name: f) }

    visit hello_work_agencies_path
  end
  
  it { should have_selector('title', text: 'Agências Hello Work') }
  
  it { should have_selector('h1', text: 'Agências Hello Work') }

  it 'should list all prefectures' do 
    Prefecture.all.each do |prefecture|
      should have_selector('li', text: prefecture.name)
    end
  end

  it { should have_selector('h3', text: 'Onde encontrar na sua província') }
end

describe 'Agency / Gifu-ken page' do
  subject { page }
  before do
    @data = Agency.new('gifu-ken')
    @offices = @data.find_offices
    visit '/agencias-hello-work/gifu-ken'
  end
  it { should have_selector('h1', text: 'Agências da Hello Work em Gifu-ken') }
  it 'should list all offices in the city' do
    @offices.each do |office|
      should have_selector('td', text: office['name'])
      should have_selector('td', text: office['address'])
      should have_selector('td', text: office['reception'])
      should have_selector('td', text: office['phone'])
    end
  end
end

describe 'Agency / when no offices found' do
  subject { page }
  before do
    @data = Agency.new('akita-ken')
    @offices = @data.find_offices
    visit '/agencias-hello-work/akita-ken'
  end
  it { should have_selector('h1', text: 'Agências da Hello Work em Akita-ken') }
  it { should have_selector('h2', text: 'Desculpe, não temos registro de escritórios da Hello Work em Akita-ken') }
end

describe 'Agency / Invalid page' do
  subject { page }

  before { visit '/agencias-hello-work/invalid' }

  it { should have_error_message('Não foi possível encontrar a província solicitada.') }
end