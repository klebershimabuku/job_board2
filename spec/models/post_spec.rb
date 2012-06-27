# encoding: utf-8

# == Schema Information
#
# Table name: posts
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  description  :text
#  location     :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  status       :string(255)     default("pending")
#  tags         :string(255)
#  views        :integer
#  user_id      :integer
#  published_at :datetime
#  expired_at   :datetime
#

require 'spec_helper'

describe Post do 

  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :location }
  it { should respond_to :status }
  it { should respond_to :tags }
  it { should respond_to :views }
  it { should respond_to :user_id }
  it { should respond_to :published_at }
  it { should respond_to :expired_at }

  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :location }
  
  describe 'new post' do
    before do
      @post = FactoryGirl.create(:post)
    end
    
    it { @post.published_at.should be_nil }
    it { @post.expired_at.should be_nil }
  end
  
  describe '#publish' do
    before do
      @post = FactoryGirl.create(:post)
      @post.publish
    end
    it { @post.published_at.should_not be_nil }
    it { @post.status.should be_eql('published') }
  end

  describe '#published?' do
    before do
      @post = FactoryGirl.create(:post)
      @post.publish
    end
    it { @post.published?.should be_true }
    it { @post.status.should be_eql('published') }
  end
  
  describe '#expired?' do
    before do
      @post = FactoryGirl.create(:post)
      @post.expire
    end
    it { @post.expired?.should be_true }
    it { @post.status.should be_eql('expired') }
  end
    
  describe '#expire' do
    before do
      @post = FactoryGirl.create(:post)
      @post.expire
    end
    it { @post.expired_at.should_not be_nil }
    it { @post.status.should be_eql('expired') }
  end

  describe ".approved_filter_by_tag" do 
    before do 
      
      Post.delete_all

      @attributes = { title: 'New job', description: 'work with us today', location: 'Shizuoka-ken, Aichi-ken', status: 'approved' }
      Post.create!(@attributes)
      Post.create!(@attributes.merge(status: 'pending'))

      @f = Post.approved_filter_by_tag('aichi-ken')
    end
    it { @f.size.should == 1 }
  end

  describe "#generate_tags" do 

    before(:each) { @attributes = { title: 'New job', description: 'work with us today', location: 'Shizuoka-ken' } }

    context "when location is 'Shizuoka-ken'" do
      before { @post = Post.create!(@attributes) }
      it { @post.tags.should == 'shizuoka-ken' }
    end

    context "when location is 'Aichi-ken'" do 
      before { @post = Post.create!(@attributes.merge(location: 'Aichi-ken')) }
      it { @post.tags.should == 'aichi-ken' }
    end
    context "when location is 'Kanagawa-ken, Yokohama-shi'" do 
      before { @post = Post.create!(@attributes.merge(location: 'Kanagawa-ken, Yokohama-shi')) }
      it { @post.tags.should == 'kanagawa-ken' }
    end
    context "when location is 'Kanagawa-ken, Yokohama-shi, Gifu-ken, Tochigi-ken'" do 
      before { @post = Post.create!(@attributes.merge(location: 'Kanagawa-ken, Yokohama-shi, Gifu-ken, Tochigi-ken')) }
      it { @post.tags.should == 'kanagawa-ken,gifu-ken,tochigi-ken' }
    end
  end

  describe '#set_as_pending' do 
    let(:post) { FactoryGirl.create(:post) }
    it { post.status.should be_eql 'pending' }
  end

  describe '#suspend!' do 
    let(:post) { FactoryGirl.create(:post) }
    before { post.suspend! }
    it { post.status.should be_eql 'suspended' }
    it { post.status.should_not be_eql 'pending' }
  end

  describe '#suspended?' do 
    let(:post) { FactoryGirl.create(:post) }

    context 'should be false' do 
      before { post.suspended? }
      it { post.suspended?.should be_false }
    end

    context 'should be true' do 
      before { post.suspend! }
      it { post.suspended?.should be_true }
    end
  end

  describe '.approved' do 
    let(:p1) { FactoryGirl.create(:post, status: 'approved') }
    let(:p2) { FactoryGirl.create(:post, status: 'approved') }
    let(:p3) { FactoryGirl.create(:post, status: 'pending') }
    let(:p4) { FactoryGirl.create(:post, status: 'approved') }
    it { Post.approved.should_not include(p3) }
    it { Post.approved.should include(p1,p2,p4) }
  end
end
