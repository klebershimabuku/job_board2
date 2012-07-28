require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe 'Home Page' do
    before(:each) { visit root_path }
    it "should have the right title" do
      should have_selector('title', :text => full_title('') )
    end
    it "should not have a custom page title" do
      should_not have_selector('title', :text => "Home -")
    end
  end

  describe "Help page" do
    before(:each) { visit ajuda_path }
    it "should have the content 'Ajuda' " do
      should have_selector('h1', :text => 'Ajuda')
    end
    it "should have the right title" do
      should have_selector('title', :text => full_title('Ajuda') )
    end
  end

  describe "About page" do
    before(:each) { visit sobre_path }
    it "should have the content 'Sobre'" do
      should have_selector('h1', :text => 'Sobre')
    end
    it "should have the right title" do
      should have_selector('title', :text => full_title('Sobre') )
    end
  end

  describe "Contact page" do
    before(:each) { visit contato_path }
    it "should have the content 'Contact'" do
      should have_selector('h1', :text => 'Contato')
    end
    it "should have the right title" do
      should have_selector('title', :text => full_title('Contato') )
    end
  end
end
