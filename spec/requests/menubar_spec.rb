# encoding: utf-8

require 'spec_helper'

describe "MenuBar" do
  context 'send a new job post button' do

    context 'display the link button' do

      it 'display button' do
        visit posts_path

        page.should have_link('Enviar anúncio de emprego', href: new_post_path)
      end

      context 'for logged-in users' do

        context 'when publisher' do

          let(:publisher_with_contact_info)     { Factory(:publisher_with_contact_info) }
          let(:publisher_without_contact_info)  { Factory(:publisher_without_contact_info, email: 'publisher@shigotodoko.com') }

          context 'and have created company-info' do
            before do
              valid_signin(publisher_with_contact_info)
              click_link('Enviar anúncio de emprego')
            end

            it 'display the right title' do
              page.should have_selector("h1", text: "Novo anúncio")
            end
          end

          context 'and have not created company-info' do
            before do
              valid_signin(publisher_without_contact_info)
              click_link('Enviar anúncio de emprego')
            end

            it 'display the right title' do
              page.should have_selector("p", text: "Você ainda não adicionou as informações para contato.")
            end
          end
        end

        context 'when user' do
          let(:user) { Factory(:user) }

          before do
            valid_signin(user)
            click_link('Enviar anúncio de emprego')
          end

          it { page.should have_content("Acesso Negado") }
        end

      end

      context 'for non logged out' do

        before do
          visit root_path
          click_link('Enviar anúncio de emprego')
        end

        it { page.should have_content('Login') }

      end

    end
  end
end