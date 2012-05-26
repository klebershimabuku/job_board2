require 'spec_helper'

describe UsersController do 
  include Devise::TestHelpers

  describe 'GET welcome' do

    context 'for just signup users' do
      login_user
      
      it 'for just signup users' do
        get :welcome
        response.should be_successful
      end
    end

    context 'for logged-in users' do
      login_custom_user
  
      it 'redirect to user profile' do 
        get :welcome
        response.should redirect_to root_path
      end
      it 'should have a current_user' do
        subject.current_user.should_not be_nil
      end
    end

    context 'for non logged-in users' do
      before(:each) { get :welcome }
      it { response.should redirect_to new_user_session_path }
      it { response.should_not be_successful }
    end
  end

  describe 'GET index' do

    context '#index as admin' do 
      login_admin
      it 'as admin' do 
        get 'index'
        response.should be_successful
      end
    end

    context '#index as non admin' do
      it 'as guest' do
        get 'index'
        response.should_not be_successful
      end
    end
  end

  describe 'GET show' do
    let(:user) { FactoryGirl.create(:user) }

    context 'for logged-in user' do 
      login_user
      before { get :show, id: user }
      it 'should find a user and return object' do
        assigns[:user].name.should == user.name
      end
      xit { response.should be_successful }
    end

    context 'for non logged-in user' do
      before do
        @user = FactoryGirl.create(:user)
        get :show, id: @user
      end
      it 'should find a user and return object' do
        assigns[:user].name.should == @user.name
      end
      it 'deny access' do
        response.should_not be_successful
      end
    end
  end

  describe 'GET edit' do
    let(:user) { FactoryGirl.create(:user)  }
    let(:another_user) { FactoryGirl.create(:user, email: 'anotheruser@example.com') }

    describe 'for logged-in users' do

      before(:each) { sign_in user }

      context 'can edit their current profile' do
        before { get :edit, id: user }
        it { response.should be_successful }
      end

      context 'cannot edit other users profile' do
        before { get :edit, id: another_user }
        it { response.should_not be_successful }
        it { response.should redirect_to root_path }
      end

    end

    describe 'for non logged-in users' do
      before { get :edit, id: user }
      it { response.should_not be_successful }
    end
  end

  describe 'PUT update' do
    let(:user) { FactoryGirl.create(:user, email: 'user@example.com') }
    let(:other_user) { FactoryGirl.create(:user, email: 'otheruser@example.com') }
    
    describe 'for logged-in users' do

      describe 'when updating their own profile' do

        before { sign_in user }

        context 'with valid information' do
          before do
            put :update, id: user
          end
          it { response.should redirect_to user_path(user) }
          it { response.should_not redirect_to new_user_session_path }
        end

        context 'with invalid information' do
          before do
            put :update, id: user, email: 'user@a'
          end
          it { response.should render_template(action: :edit) }
          it { flash.should_not be_nil }
        end

        it { response.should be_successful }
      end

      context 'when updating others information' do
       before do
          sign_in user
          put :update, id: other_user
        end
        it { response.should redirect_to root_path }
        it { response.should_not redirect_to user_path(other_user) }
      end

    end

    context 'for non logged-in users' do
      before { put :update, id: user }
      it 'redirects to root' do
        response.should redirect_to root_path
      end
      it 'should not redirect to the profile page' do
        response.should_not redirect_to user_path(user)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin) { FactoryGirl.create(:admin) }
    describe 'for logged-in users' do
      context 'when user is a member' do
        before do
          sign_in user
          delete :destroy, id: user
        end
        it { response.should redirect_to root_path }
        it { flash[:success].should_not be_nil }
      end

      context 'when user is an admin' do
        before do
          sign_in admin
          delete :destroy, id: user
        end
        it { response.should redirect_to users_path }
        it { flash[:success].should_not be_nil }
      end

      it { response.should be_successful }

    end
    context 'for non logged-in users' do
      before { delete :destroy, id: user }
      it { response.should redirect_to root_path }
      it { flash[:success].should be_nil }
      it { flash[:alert].should_not be_nil }
    end
  end
end