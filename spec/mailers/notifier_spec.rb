# encoding: utf-8
require 'spec_helper'

describe Notifier do 
  describe 'warning about a new post on the system' do
    post = FactoryGirl.create(:pending_post)
    
    let(:email) { Notifier.new_post_submitted(post) }

    it 'should send the email to the right email address' do 
      email.subject.should match post.title
      email.to.should include 'admin@shigotodoko.com'
      email.from.should include 'no-reply@shigotodoko.com'
    end

    it 'should contain information about the post' do 
      email.body.should match post.title
      email.body.should match post.description
      email.body.should match post.location
      email.body.should match post.tags
    end
  end
end


