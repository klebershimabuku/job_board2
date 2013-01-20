#encoding: utf-8
require 'spec_helper'

describe "Admin Dashboard" do

  let(:admin) { Factory.create(:admin) }
  let(:publisher) { Factory.create(:publisher_with_contact_info, email: 'publisher@shigotodoko.com') }
  let(:pending_post) { Factory.create(:pending_post, user: publisher) }

  before do
    valid_signin(admin)
    visit admin_post_path(pending_post.id)
  end

  context "on publish button click" do

    before { click_link 'Publicar' }

    it 'should post on facebook' do 
      #page.should have_content('Anúncio publicado com sucesso')
    end

  end
end