# encoding: utf-8
require 'spec_helper'

describe ContactInfosController do 
  include Devise::TestHelpers
  render_views

  def mock_contactinfo(stubs={})
    (@mock_contactinfo ||= mock_model(ContactInfo).as_null_object).tap do |ci|
      ci.stub(stubs) unless stubs.empty?
    end
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user, role: 'announcer')
    sign_in @user
  end

  describe '#new' do 
    it 'should be be_successful' do
      @contact_info = mock(ContactInfo)
      get :new, user_id: @user.id
      ContactInfo.stub(:new).and_return(@contact_info)
      assigns(:contact_info).should_not be_nil
      response.should be_successful
    end
  end

  describe '#create' do 

    before { @contact_info = mock(ContactInfo) }

    context 'successful' do
      it 'when creating a contact info' do 
        @contact_info.stub(:build_contact_info).and_return(@contact_info)
        post :create, user_id: @user.id
      end

      it 'should save' do 
        @contact_info.stub(:save).and_return(true)
        post :create, user_id: @user.id
      end

      it 'should displays a successful message' do 
        post :create , user_id: @user.id, contact_info: { title: 'params', description: 'params' }
        flash[:success].should be_eql 'Informação de contato salva com sucesso.'
      end

      it 'should redirect to user page' do
        post :create, user_id: @user.id, contact_info: { title: 'params', description: 'params' }
        response.should redirect_to user_path(@user)
      end
    end
    context 'failure' do

      before { post :create, user_id: @user.id }

      it 'when creating a contact info' do 
        @contact_info.stub(:build_contact_info).and_return(@contact_info)
      end

      it 'should not save' do 
        @contact_info.stub(:save).and_return(false)
      end

      it 'should re-render the new page'
    end
  end

  describe '#edit' do 
    
    before do
      @user          = FactoryGirl.create(:user)
      @contact_info  = FactoryGirl.create(:contact_info, user_id: @user.id)
      get :edit, id: @contact_info.id, user_id: @user.id
    end

    it 'should find object' do 
      ContactInfo.stub!(:find).and_return(@contact_info)
    end

    it 'should assigns @contact_info' do 
      assigns(:contact_info).should_not be_nil
    end
  end

  describe '#update' do 
    describe 'successs' do 
      before do 
        @contact_info = FactoryGirl.create(:contact_info, user_id: @user.id)
        ContactInfo.stub!(:find).with(@contact_info.id.to_param).and_return(@contact_info)
      end

      it 'should update object' do 
        ContactInfo.any_instance.
          should_receive(:update_attributes).
          with({"these" => "params"})
        put :update, :id => @contact_info, user_id: @user.id, :contact_info => {"these" => "params"}
      end

      it 'should display success message' do 
        put :update, :id => @contact_info, user_id: @user.id, contact_info: {title: 'params', description: 'params'}
        flash[:success].should_not be_blank
      end

      it 'should redirect to the user page' do 
        put :update, id: @contact_info, user_id: @user.id, contact_info: {title: 'params', description: 'params'}
        response.should redirect_to user_path(@user)
      end

    end
    describe 'failure'
  end

  describe'#destroy' do 
    before do 
      @contact_info = FactoryGirl.create(:contact_info, user_id: @user.id)
    end

    it 'should find object' do 
      ContactInfo.stub!(:find).and_return(@contact_info)
    end

    it 'should destroy the object' do 
      @contact_info.stub!(:destroy).and_return(true)
      delete :destroy, id: @contact_info.id.to_param, user_id: @user.id
    end

    it 'should redirect to the user page' do 
      delete :destroy, id: @contact_info, user_id: @user.id
      response.should redirect_to user_path(@user)
    end
  end

end