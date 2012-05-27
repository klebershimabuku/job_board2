# encoding: utf-8
require 'spec_helper'

describe "PostPages" do
  
  subject { page }
  
  before { Post.delete_all }

  describe "Index Post Page" do 
    before do
      3.times { FactoryGirl.create(:post, status: 'approved') }
      visit posts_path
    end
    it { should have_selector('title', text: 'Empregos no Japão') }
    it { should have_selector('h1', text: 'Descubra onde trabalhar') }

    it 'lists each approved job' do 
      Post.approved.each do |p|
        should have_selector('li', text: p.title)
        should have_selector('li', text: p.location)
        should have_link(p.tags, href: tags_filter_post_path(p.tags) )
      end
    end
  end

  describe "Tags Post Page" do 
    
    context 'with data present' do 

      context "when there's one tag" do 
        before do 
          @title = 'Resultados para Aichi-ken'
          2.times { FactoryGirl.create(:post, tags: 'aichi-ken') }
          visit tags_filter_post_path('aichi-ken')
        end
        it { should have_selector('title', text: @title) }
        it { should have_selector('h1', text: @title) }
        # 
        # TODO: implement this test correctly
        # actually its probably never been called
        #
        it 'lists each filtered job by tag'
          #Post.find_all_by_tags('aichi-ken').each do |p|
          #  should have_link(p.title)
          #  should have_selector('li', text: p.created_at)
          #end
        #end
      end

      context "when there's two or more tags" do 
        before do 
          @title = 'Resultados para Aichi-ken'
          2.times { FactoryGirl.create(:post, tags: 'aichi-ken,shizuoka-ken') }
          visit tags_filter_post_path('aichi-ken')
        end
        it { should have_selector('title', text: @title) }
        it { should have_selector('h1', text: @title) }
        # 
        # TODO: implement this test correctly
        # actually its probably never been called
        #
        it 'lists each filtered job by tag'
          #Post.find_all_by_tags('aichi-ken').each do |p|
          #  should have_link(p.title)
          #  should have_selector('li', text: p.created_at)
          #end
        #end
      end
    end

    context 'without data present' do 
      before do 
        @tag = 'aichi-ken'
        @title = 'Resultados para Aichi-ken'
        visit tags_filter_post_path(@tag)
      end
      it { should have_selector('title', text: @title) }
      it { should have_selector('h1', text: @title) }
      it { should have_content("Nenhum resultado encontrado para #{@tag}") }
      it { should have_link('Retornar à página principal de anúncios', href: posts_path)}
    end
  end

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
    before do
      @post = FactoryGirl.create(:post)
      visit post_path(@post)
    end
    it { should have_selector('title', text: @post.title) }
    it { should have_selector('h1', text: @post.title) }
    it { should have_content(@post.description) }
    it { should have_content(@post.location) }
    it { should have_content(@post.tags) }
    it { should have_link('Retornar à página principal de anúncios', href: posts_path) }
  end
end