# encoding: utf-8
require 'spec_helper'

describe "PostPages" do
  
  subject { page }
  
  before { Post.delete_all }

  describe "Index Post Page" do 
    before do
      user = FactoryGirl.create(:user)
      contact_info = FactoryGirl.create(:contact_info, user_id: user.id)
      
      FactoryGirl.create(:post, status: 'published', tags: 'aichi-ken', user_id: user.id)
      FactoryGirl.create(:post, status: 'published', tags: 'gifu-ken', user_id: user.id)
      FactoryGirl.create(:post, status: 'published  ', tags: 'tochigi-ken,gunma-ken', user_id: user.id)

      visit posts_path
    end
    it { should have_selector('title', text: 'Empregos no Japão') }
    it { should have_selector('h4', text: 'Filtre anúncios por região') }

    it 'lists each published job' do 
      Post.published.each do |p|
        should have_selector('h3', text: p.title)
        should have_selector('p', text: p.location)
        should have_link(p.tags, href: tags_filter_post_path(p.tags) )
      end
    end

    it 'lists each tag' do 
      Post.available_tags.each do |tag|
        should have_selector('li', text: tag)
      end
    end

    context 'should not include posts older than 3 months' do 
      before do
        user = FactoryGirl.create(:user)
        @post = FactoryGirl.create(:post, status: 'published', tags: 'gifu-ken', user_id: user.id, created_at: 4.months.ago)
        Post.expire_older_than_3_months
        visit posts_path 
      end

      it { Post.published.should_not include(@post) }
    end

  end

  describe "Tags Post Page" do 
    
    context 'with data present' do 

      context "when there's one tag" do 

        before do 

          @title = 'Vagas em Aichi-ken'

          contact_info = FactoryGirl.create(:contact_info)
          user = FactoryGirl.create(:user)
          post = FactoryGirl.create(:post, title: 'Job in Aichi', description: 'anytext', status: 'published', location: 'aichi-ken', user: user)


          visit tags_filter_post_path('aichi-ken')
        end
        it { should have_selector('title', text: @title) }
        it { should have_selector('h3', text: @title) }

        it 'lists each filtered job by tag' do
          Post.published_filter_by_tag('aichi-ken').each do |p|
            page.should have_selector('li', text: p.title)
          end
        end
      end

      context "when there's two or more tags" do 
        before do 
          @filter = 'aichi-ken'

          @title = 'Vagas em Aichi-ken'

          contact_info = FactoryGirl.create(:contact_info)

          user = FactoryGirl.create(:user)
          
          post1 = FactoryGirl.create(:post, title: 'Job in Aichi', description: 'anytext', status: 'published', location: 'aichi-ken', user: user)

          post2 = FactoryGirl.create(:post, title: 'Job in Yokohama-shi', description: 'anytext', status: 'published', location: 'gunma-ken,osaka-fu,aichi-ken')

          visit tags_filter_post_path(@filter)
        end
        it { should have_selector('title', text: @title) }
        it { should have_selector('h3', text: @title) }

        it 'lists each filtered job by tag' do
          Post.published_filter_by_tag('aichi-ken').each do |p|
            page.should have_selector('li', text: p.title)
          end
        end
      end
    end

    context 'without data present' do 
      before do 
        @tag = 'aichi-ken'
        @title = 'Vagas em Aichi-ken'
        visit tags_filter_post_path(@tag)
      end
      it { should have_selector('title', text: @title) }
      it { should have_selector('h3', text: @title) }
      it { should have_content("Nenhum resultado encontrado para #{@tag}") }
      it { should have_link('Retornar à página principal de anúncios', href: posts_path)}
    end
  end

  describe "New Post Page" do 
    let(:counter) { Post.count }
    let(:user) { FactoryGirl.create(:user, role: 'publisher') }

    context 'with non signed-in users' do 
      before { visit new_post_url }
      it { should have_selector('title', text: 'Entrar') }
    end
    
    context 'with signed in users' do 
      before do 
        valid_signin user
        contact_info = FactoryGirl.create(:contact_info, user_id: user.id)
        visit new_post_path
      end
      it { should have_selector('h1', text: 'Novo anúncio') }

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
            click_button :submit
          end
          it 'should redirect to a successful page' do
            expect { response.should redirect_to successful_submitted_posts_path }
          end
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
    before do 
      @user = FactoryGirl.create(:user, role: 'publisher')
      @post = FactoryGirl.create(:post, user_id: @user.id)
      visit edit_post_path(@post)
    end

    context 'when logged-in with the wrong user' do 
      before do
        valid_signin FactoryGirl.create(:user, email: 'wronguser@example.com')
        get edit_post_path(@post)
      end
      it { response.should redirect_to root_path }
    end


    context 'when logged-in with the right user' do 
      before do
        valid_signin @user
        visit edit_post_path(@post)
      end
      it { should have_selector('title', text: 'Edição de anúncio') }
      it { should have_selector('h1', text: 'Edição de anúncio') }

      context 'on save' do
        let(:new_title) { 'This is a new title' }
        let(:new_description) { 'and sure, this is a new description' }
        let(:new_location) { 'Kanagawa-ken, Yokohama-shi' }

        context 'with valid information' do 
          
          before do
            fill_in "Título",       with: new_title
            fill_in "Descrição",    with: new_description
            fill_in "Localização",  with: new_location
            click_button 'Salvar'
          end

          it { should have_success_message('Anúncio modificado com sucesso.') }
          it { should have_selector('title',text: new_title)}
        end
  
        context 'with invalid information' do 
          before do
            fill_in "Título",       with: new_title
            fill_in "Descrição",    with: ''
            fill_in "Localização",  with: new_location
            click_button 'Salvar'
          end
          it { should have_content('Os seguintes erros foram encontrados') }
        end
      end
    end

    context 'when not logged-in' do 

      before { get edit_post_path(@post) }

      it { response.should redirect_to root_path }
      it { should have_selector('title', text: 'ShigotoDoko') }
    end
  end

  describe "Show Post Page" do 

    before do
      @user = FactoryGirl.create(:user, role: 'publisher')
      @contact_info = FactoryGirl.create(:contact_info, user_id: @user.id)
      @post = @user.posts.build(title: 'Awesome job!',
                                description: 'Work with us today',
                                location: 'Aichi-ken, Toyohashi-shi')
      @post.save
      visit post_path(@post)
    end

    it { should have_selector('title', text: @post.title) }
    it { should have_selector('h1', text: @post.title) }
    it { should have_content(@post.description) }
    it { should have_content(@post.location) }
    it { should have_content('publicado') }
    it "should have content 'Nome da empresa' " do 
      should have_content(@contact_info.title)
    end
    it "should have content 'Dados da empresa' " do 
      should have_content(@contact_info.description)
    end

    it 'should have all the tags' do
      @post.tags.split(',').each do |tag|
        should have_link(tag, href: tags_filter_post_path(tag))
      end
    end

    context 'when visiting as guest' do 
      before { visit post_path(@post) }
      it { should_not have_link('Editar anúncio', href: edit_post_path(@post)) }
      it { should have_link('Retornar à página principal de anúncios', href: posts_path) }
    end

    context 'when visiting a suspended post as author' do 
      before do 
        valid_signin @user
        @post.suspend!
        visit post_path(@post)
      end
      it { should_not have_link('Editar anúncio', href: edit_post_path(@post)) }
      it { should_not have_link('Suspender anúncio', href: suspend_alert_post_path(@post)) }
      it { should have_content('Este anúncio está suspenso e não pode ser editado.') }
      it { should have_link('Retornar à página principal de anúncios', href: posts_path) }
    end

    context 'when visiting a not-suspended post as author' do 
      before do 
        valid_signin @user
        visit post_path(@post)
      end
      it { should have_link('Editar anúncio', href: edit_post_path(@post)) }
      it { should have_link('Suspender anúncio', href: suspend_alert_post_path(@post)) }
      it { should have_link('Retornar à página principal de anúncios', href: posts_path) }
    end

  end

  describe "Suspend Post Page" do 
    before do
      @user = FactoryGirl.create(:user, role: 'publisher')
      @post = @user.posts.build(title: 'Awesome job!',
                                description: 'Work with us today',
                                location: 'Aichi-ken, Toyohashi-shi')
      @post.save
      visit suspend_alert_post_path(@post)
    end

    context 'when visiting as guest' do 
      it { should_not have_link('Suspender', href: suspend_post_path(@post)) }
      it { should have_selector('title', text: 'ShigotoDoko') } # redirect_to root_path
    end

    context 'when visiting as author' do 
      before do
        valid_signin @user
        visit suspend_alert_post_path(@post)
      end
      it { should have_link('Suspender', href: suspend_post_path(@post)) }
      it { should have_selector('title', text: 'Suspensão de anúncio') }
      it { should have_selector('h1', text: @post.title) }
    end
  end
end