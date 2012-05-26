# encoding: utf-8
require 'spec_helper'

describe "PostPages" do
  
  subject { page }
  before { Post.delete_all }

  describe "New Post Page" do 
    let(:counter) { Post.count }
    let(:user) { FactoryGirl.create(:user) }

    context 'with non signed-in users' do 
      before { visit new_post_url }
      it { should have_selector('title', text: 'Entrar') }
    end

    context 'with signed in users' do 
      before do 
        valid_signin user
        visit new_post_path
      end
      it { should have_selector('h1', text: 'Novo anúncio') }
      it "should have content 'Nome da empresa' "
      it "should have content 'Dados da empresa' "

      # 
      # with valid information
      #
      context "should create a new post with valid information" do
        before do
          fill_in "Título", with: "Choose a right title"
          fill_in "Descrição", with: "Write some requisites for this job"
          fill_in "Localização", with: "Shizuoka-ken"
        end

        it "should create a new post" do
          expect { click_button :submit }.to change(Post, :count).by(1)
        end

        context 'redirects to a successful page' do
          before do
            post user_session_path(user: { email: user.email, password: user.password } )
            post posts_path(post: {title: 'title', description: 'some text', location: 'japan'} )
          end
          specify { response.should redirect_to successful_submitted_posts_path }
        end

        context "when post is successful submited" do
          before { click_button :submit }

          it "display a nice message" do
            should have_selector('h1', text: "Seu anúncio foi enviado com sucesso.")
          end

          it { should have_link('Retornar à página inicial', href: root_path) }
        end
        
        it "should not be accessible for non-registered users" do 
          expect { response.should redirect_to new_user_session_path }
        end
      end

      #
      # with invalid information
      #
      context "should NOT create a new post with invalid information" do
        before do
          fill_in "Título", with: ""
          fill_in "Descrição", with: ""
          fill_in "Localização", with: ""
        end

        it "should NOT create a new post" do
          expect { click_button :submit }.to_not change(Post, :count).by(1)
        end

        context "if validation fails, returns a message" do
          before { click_button :submit }
          it { should have_content("erro") }
        end
      end
    end
  end

  describe "Edit Post Page" do 
  end

  describe "Show Post Page" do 
  end
end