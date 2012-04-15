require 'spec_helper'

describe "StaticPages" do

  subject { page }
  let(:base_title) { "ShigotoDoko" }

  describe 'Home Page' do
    before(:each) { visit '/static_pages/home' }
    it "should have the content 'Bem vindo'" do
      should have_selector('h1', :text => 'Bem vindo')
    end
    it "should have the right title" do
      should have_selector('title', :text => "ShigotoDoko")
    end
    it "should not have a custom page title" do
      should_not have_selector('title', :text => "Home -")
    end
  end

  describe "Help page" do
    before(:each) { visit '/static_pages/help' }
    it "should have the content 'Ajuda' " do
      should have_selector('h1', :text => 'Ajuda')
    end
    it "should have the right title" do
      should have_selector('title', :text => "Ajuda - #{base_title}")
    end
  end

  describe "About page" do
    before(:each) { visit '/static_pages/about' }
    it "should have the content 'Sobre'" do
      should have_selector('h1', :text => 'Sobre')
    end
    it "should have the right title" do
      should have_selector('title', :text => "Sobre - #{base_title}")
    end
  end

  describe "Contact page" do
    before(:each) { visit '/static_pages/contact' }
    it "should have the content 'Contact'" do
      should have_selector('h1', :text => 'Contato')
    end
    it "should have the right title" do
      should have_selector('title', :text => "Contato - #{base_title}")
    end
  end
end
