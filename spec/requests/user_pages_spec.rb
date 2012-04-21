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
        it { should have_selector('h2', text: 'Seu cadastro foi efetuado com sucesso') }
        it { should have_info_message('Login efetuado com sucesso') }
        it { should have_link('Sair', href: destroy_user_session_path) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
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
        before { valid_signin user }
        it { should have_link('Perfil', href: user_path(user))}
        it { should have_link('Sair', href: destroy_user_session_path) }
        it { should_not have_link('Entrar', href: new_user_session_path)}
        it { should have_selector('h1', text: user.name)}
        it { should have_info_message("Login efetuado com sucesso!")}

        describe "followed by a signout" do
          before { click_link 'Sair' }
          it { should have_link('Entrar', href: new_user_session_path) } 
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

end
