# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, pr imary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do

  before(:each) do
    @user = User.new(name: "Foobar Rails", 
                    email: "foobar@rails.com", 
                    password: "EncrypTeDPa$$w0rD", 
                    password_confirmation: "EncrypTeDPa$$w0rD"
                  )
  end

  subject { @user }
    
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:reset_password_token) }
  it { should respond_to(:reset_password_sent_at) }
  it { should respond_to(:remember_created_at) }
  it { should respond_to(:sign_in_count) }
  it { should respond_to(:current_sign_in_at) }
  it { should respond_to(:last_sign_in_at) }
  it { should respond_to(:current_sign_in_ip) }
  it { should respond_to(:last_sign_in_ip) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe "when name is too longe" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        @user.email = address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com user_example@foo.org EXAMPLE.user@foo.com first.lst@foo.jp]
      addresses.each do |address|
        @user.email = address
        @user.should be_valid
      end
    end
  end

  describe "when email is duplicate" do
    before do
      duplicate_email = @user.dup
      duplicate_email.email = @user.email.upcase
      duplicate_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = 'confirm' }
    it { should_not be_valid }
  end

  describe "when password confirmation is blank" do
    before { @user.password_confirmation = '' }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end
end
