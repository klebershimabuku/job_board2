require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe 'Home Page' do
    before(:each) { visit '/static_pages/home' }
    it "should have the content 'Bem vindo'" do
      should have_selector('h1', :text => 'Bem vindo')
    end
    it "should have the right title" do
      should have_selector('title', :text => "Home - ShigotoDoko")
    end
  end

  describe "Help page" do
    before(:each) { visit '/static_pages/help' }
    it "should have the content 'Ajuda' " do
      should have_selector('h1', :text => 'Ajuda')
    end
    it "should have the right title" do
      should have_selector('title', :text => "Ajuda - ShigotoDoko")
    end
  end

  describe "About page" do
    before(:each) { visit '/static_pages/about' }
    it "should have the content 'Sobre'" do
      should have_selector('h1', :text => 'Sobre')
    end
    it "should have the right title" do
      should have_selector('title', :text => "Sobre - ShigotoDoko")
    end
  end
end
