#encoding: utf-8
require 'spec_helper'

describe "UserPages" do

  subject { page }
  
  describe "sign-up page" do

    before { visit new_user_registration_path }
    let(:submit) { "Cadastrar" }

    it { should have_selector('h1', text: 'Cadastro') }
    it { should have_selector('title', text: 'Cadastro') }
    
    describe "with invalid information" do
      it "should not create a new user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "error messages" do
        before { click_button submit }
        it { should have_content('erro') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Nome",                 with: "Kleber Shimabuku"
        fill_in "Email",                with: "klebershimabuku@example.com"
        fill_in "Senha",                with: "foobar"
        fill_in "Confirme sua senha",   with: "foobar"
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('klebershimabuku@example.com') }
        it { should have_selector('title', text: 'Cadastro efetuado com sucesso') }
        it { should have_selector('h1', text: "Parabéns!") }
        it { should have_selector('h2', text: 'Seu cadastro foi efetuado com sucesso') }
        it { should have_info_message('Login efetuado com sucesso') }
        it { should have_link('Sair', href: destroy_user_session_path) }
      end
    end
  end

  describe "authentication page" do
    subject { page }

    describe "signin page" do
      before { visit new_user_session_path }
      it { should have_selector('title', text: "Entrar") }
      it { should have_selector('h1', text: "Iniciar sessão") }

      describe "with invalid information" do
        before { click_button 'Entrar' }
        it { should have_selector('h1', text: "Iniciar sessão")}
        it { should have_error_message("E-mail ou senha inválidos.") }

        describe "after visiting another page" do
          before { click_link 'Home'}
          it { should_not have_selector('div.alert.alert-error') }
        end
      end
      
      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        let(:admin) { FactoryGirl.create(:admin) }
        before { valid_signin user }

        context "as user" do
          it { should have_link('Perfil', href: user_path(user)) }
          it { should have_link('Sair', href: destroy_user_session_path) }
          it { should have_link('Configurações', href: edit_user_path(user)) }
          it { should_not have_link('Entrar', href: new_user_session_path)}
          it { should have_selector('h1', text: user.name) }
          it { should have_info_message("Login efetuado com sucesso!") }
        end

        context "as admin" do
          before do 
            click_link 'Sair'
            valid_signin admin
          end
          it { should have_link('Usuários', href: users_path) }
        end

        context "followed by a signout" do
          before { click_link 'Sair' }
          it { should have_link('Entrar', href: new_user_session_path) } 
        end

      end

      describe "authorization" do
        describe "as non-admin member" do
          let(:user) { FactoryGirl.create(:user) }
          let(:non_admin) { FactoryGirl.create(:user) }
          before { valid_signin non_admin }
          describe "submitting a DELETE request to the Users#destroy action" do
            before { delete user_path(user) }
            specify { response.should redirect_to root_path }
          end
        end
        describe "for non-signed-in users" do
          let(:user) { FactoryGirl.create(:user) }

          describe "in the UsersController" do
            context "visiting the edit page" do
              before { visit edit_user_path(user) }
              it { should have_selector('title', text: "ShigotoDoko") }
            end
            context "submitting to the update action" do 
              before { put user_path(user) }
              specify { response.should redirect_to root_path }
            end
            context "visiting the index" do
              before { visit users_path }
              it { should have_selector('title', text: "ShigotoDoko") }
            end
          end
        end
      end
    end
  end

  describe "forgotten password page" do
    let(:user) { FactoryGirl.create(:user) }    
    before { visit new_user_password_path }

    it { should have_selector('title', text: "Esqueci minha senha")}
    it { should have_selector('h1', text: "Esqueceu sua senha?")}
    
    describe "with valid information" do
      before do
        fill_in "Email", with: user.email 
        click_button "Enviar instruções para definir uma nova senha" 
      end
      it { should have_info_message("Dentro de minutos, você receberá um e-mail com instruções para a troca da sua senha." )}
      it { should have_selector('h1', text: "Iniciar sessão")}

      describe "setting a new password page" do
        before do
          visit edit_user_password_path
          fill_in "Nova senha",               with: "Newpassword"
          fill_in "Confirme sua nova senha",  with: "Newpassword"
          click_button "Mudar minha senha"
        end
        pending("user password should change")
      end
    end

    describe "with invalid information" do
      before do
        fill_in "Email", with: "random@example.com"
        click_button "Enviar instruções para definir uma nova senha"
      end
      it { should have_selector('ul>li', text: "Email não encontrado")}
      it { should have_selector('h1', text: "Esqueceu sua senha?") }
    end
  end

  describe "index action" do

    context 'when admin' do 
      before do
        valid_signin FactoryGirl.create(:admin)
        FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
        FactoryGirl.create(:user, name: "Alex", email: "alex@example.com")
        visit users_path
      end

      it { should have_selector('h1', text: "Todos usuários") }
      it "list each user" do
        User.all.each do |u|
          page.should have_selector('li', text: u.name)
        end
      end
    end

    pending 'when member'
  end

  describe "show action (profile)" do

    #
    # Announcer users should only be allowed to create Posts
    #
    context 'when user is a announcer' do 
      let(:user) { FactoryGirl.create(:user, role: 'announcer') }
      before do
        2.times { FactoryGirl.create(:post, status: 'approved', user_id: user.id) }
        1.times { FactoryGirl.create(:post, status: 'pending', user_id: user.id) }
        3.times { FactoryGirl.create(:post, status: 'suspended', user_id: user.id) }
        valid_signin user
        visit user_path(user)
      end
  
      it { should have_selector('h1', text: user.name) }
      it { should have_selector('title', text: user.name) }

      it { should have_selector('h2', text: 'Meus anúncios') }
      it { should have_link('Novo anúncio', href: new_post_path) }

      it "list all posts by the current user" do 
        all_posts = Post.where('user_id = ?', user)
        all_posts.all.each do |p|
          page.should have_selector('td', text: p.title)
          page.should have_link(p.title, href: post_path(p))
          page.should have_content(p.status)
        end
      end

      describe 'contact information' do

        describe 'when information does not exist' do 

          context 'and try to create a new post' do 
            before do 
              click_link 'Novo anúncio'
            end
            it { should have_error_message('Informações para contato não encontradas.') }
            it 'should not redirect to the new post page' do 
              should have_selector('h1', text: user.name)
            end
          end

          it { should have_content('Você ainda não adicionou as informações para contato.') }
          it { should have_link('Adicionar informações para contato', href: new_user_contact_info_path(user)) }
        end

        context 'when information are present' do 
          before do 
            @info = user.build_contact_info(title: 'Padrão', 
                                   description: 'Watanabe 090-7356-9944 / Ricardo 090-7744-4974')
            @info.save!
            visit user_path(user)
          end
          it { should have_selector('h3', text: @info.title) }
          it { should have_selector('p', text: @info.description) }
          it { should have_link('Editar', href: edit_user_contact_info_path(user, @info.id)) }
          it { should have_link('Remover') }

          context "and user click on link 'Editar'" do 
            before { click_link 'Editar' }
            it { should have_selector('title', text: 'Alteração de informações para contato') }
          end
        end
      end
    end

    # 
    # Member users should only be allowed to create Curriculums
    #
    context 'when user is a member' do 
      let(:user) { FactoryGirl.create(:user, role: 'member') }
      before do
        2.times { FactoryGirl.create(:post, status: 'approved', user_id: user.id) }
        1.times { FactoryGirl.create(:post, status: 'pending', user_id: user.id) }
        3.times { FactoryGirl.create(:post, status: 'suspended', user_id: user.id) }
        valid_signin user
        visit user_path(user)
      end
      it { should have_selector('h1', text: user.name) }
      it { should have_selector('title', text: user.name) }
      it { should_not have_selector('h2', text: 'Meus anúncios') }
    end

    it { should_not have_link('Entrar') }
  end

  describe "edit action" do
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user, email: "anotheruser@mail.com") }

    describe "for non-signin users" do
      context "cannot access any edit profile page" do
        before { visit edit_user_path(user) }
        it { should have_error_message('Acesso Negado') }
      end
      context "cannot update a user profile" do
        before { put user_path(user) }
        specify { response.should redirect_to root_path }
      end
    end
    
    describe "for signin users" do

      before do
        valid_signin user
        visit edit_user_path(user)
      end

      describe "can edit only their profiles" do
        before { visit edit_user_path(another_user) }
        it { should have_selector('title', text: "ShigotoDoko") }
        it { should have_error_message('Acesso Negado') }

        context "cannot update other member profile" do
          before { put user_path(another_user) }
          specify { response.should redirect_to root_path }
          it { should have_error_message('Acesso Negado') }
        end
      end

      describe "page" do
        it { should have_selector('h1', text: "Atualize seu perfil") }
        it { should have_selector('title', text: "Edição de perfil") }
        it { should have_link('Mudar foto', href: 'http://gravatar.com/emails') }

        describe "with valid information" do
          before do 
            fill_in "Nome", with: "Random User"
            fill_in "E-mail", with: "random@user.com"
            fill_in "Senha", with: user.password
            fill_in "Confirme sua senha", with: user.password  
            click_button "Salvar alterações"
          end

          it { should have_link('Sair', href: destroy_user_session_path, method: :delete) }
          it { should have_success_message('Perfil salvo com sucesso!') }
          it { should have_selector('title', text: "Random User") }

          specify { user.reload.name.should == "Random User" }
          specify { user.reload.email.should == "random@user.com" }
        end

        describe "with invalid information" do
          before do 
            fill_in "Nome", with: "Random User"
            fill_in "E-mail", with: "random@user.com"
            fill_in "Senha", with: user.password
            fill_in "Confirme sua senha", with: nil
            click_button "Salvar alterações"
          end

          ####
          #
          # if validation fails, it should display the error on appropriate fields
          #
          ####
          it { should have_content('erro') }
          it { should have_selector('h1', text: "Atualize seu perfil") }
          it { should have_selector('title', text: "Edição de perfil") }
        end
      end
    end
  end

  describe "destroy action" do
    
    let(:user) { FactoryGirl.create(:user) }
    let(:another_user) { FactoryGirl.create(:user, email: "another@user.com") }

    describe "for signin users" do

      before do
        valid_signin user
        visit edit_user_path(user)
      end

      it { should have_link("Excluir minha conta", href: user_path(user), method: :delete) }

      context "decrement user count" do
        before { click_link "Excluir minha conta" }
        #expect { User.count }
      end
    end
    
    context "for non-signin users" do
    end
  end

  describe "pagination" do
    
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    let(:admin) { FactoryGirl.create(:admin) }

    before do
      valid_signin admin
      visit users_path
   end

    it { should have_link('Próximos') }
    its(:html) { should match('>2</a>') }

    it "should list each user" do
      User.all[0..2].each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end

  describe "delete links" do
    subject { page }
    it { should_not have_link('Excluir usuário') }

    before { 4.times { FactoryGirl.create(:user) } }
    after { User.delete_all }

    describe "as admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        valid_signin admin
        visit users_path
      end
      it "should be able to delete another user" do
        expect { click_link('Excluir usuário') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('Excluir usuário', href: user_path(admin)) }
    end
  end
end
