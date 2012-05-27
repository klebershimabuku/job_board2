  # encoding: utf-8
  require 'spec_helper'

  describe PostsController do 
    include Devise::TestHelpers
    render_views

    def mock_post(stubs={})
      (@mock_post ||= mock_model(Post).as_null_object).tap do |post|
        post.stub(stubs) unless stubs.empty?
      end
    end

    context '#index' do 
      before { get :index } 
      it { assigns(:posts).should_not be_nil }
      it { response.should be_successful }
    end

    context '#show' do 
      before { get :show, id: FactoryGirl.create(:post) }
      it { assigns(:post).should_not be_nil }
      it { response.should be_successful }
    end

    describe '#tags' do 
      context 'with data, one tag only' do
        before do
          @post = FactoryGirl.create(:post, tags: 'shizuoka-ken')
          get :tags, tags: 'shizuoka-ken'
        end
        it { assigns(:posts).should_not be_nil }
        it { response.should be_successful }
      end
      context 'with data, two tags' do
        before do
          FactoryGirl.create(:post, tags: 'shizuoka-ken,aichi-ken', status: 'approved')
          FactoryGirl.create(:post, tags: 'shizuoka-ken,aichi-ken', status: 'pending')
          FactoryGirl.create(:post, tags: 'shizuoka-ken,aichi-ken', status: 'pending')
          get :tags, tags: 'shizuoka-ken'
        end
        it { assigns(:posts).should_not be_nil }
        it { assigns(:posts).size.should == 1 }
        it { response.should be_successful }
      end
      context 'with no data' do
        before do
          Post.delete_all
          get :tags, tags: 'shizuoka-ken'
        end
        it { assigns(:posts).should be_empty }
        it { response.should be_successful }
      end
    end

    context '#new' do 
      
      context 'when logged in users' do 
        login_user

        it 'should be_successful' do 
          @post = mock(Post)
          get :new
          Post.stub(:new).and_return(@post)
          assigns(:post).should_not be_nil
          response.should be_successful
        end
      end

      context 'when non logged in users' do 
        before { get :new }
        it 'should NOT be successful' do 
          @post = mock(Post)
          Post.stub(:new).and_return(false)
          response.should_not be_successful
        end
      end
    end

    describe '#create' do
      
      @attributes = { id: 1, title: 'New post', description: 'Please add some text here', location: 'Shizuoka-ken' }

      context 'when logged in' do 

        before do 
          @user = FactoryGirl.create(:user, email: 'random@example.com')
          sign_in @user 

          @post = mock(Post, 
                      title: 'New post', 
                      description: 'Please add some text here', 
                      location: 'Anywhere' )

          # expected
          controller.current_user.posts.stub!(:build).and_return(@post)
        end

        context 'success' do 
          before { @post.should_receive(:save).and_return(true) }

          it 'should create a instance variable' do 
            post :create, post: @attributes
            assigns(:post).title.should be_eql 'New post'
          end

          it 'should redirect to the success page' do 
            post :create, post: @attributes
            response.should redirect_to successful_submitted_posts_path
          end
        end

        context 'failure' do 

          # 
          # TO BE FIXED:
          # should render the new template but instead its redirecting
          #
          it 'should render the NEW template' #do 
            #Post.stub(:new) { mock_post(save: false, errors: { any: 'error' } ) }
            #post :create, { }
            #response.code.should == '200'
            #response.should render_template('new')
          #end

          it 'should not create a new post' do 
            Post.stub(:new) { mock_post(save: false) }
            lambda do   
              post :create, post: @attributes
            end.should_not change(Post, :count)
          end
        end
      end

      context 'when NOT logged in' do
        before { post :create, post: @attributes }
        it { response.should_not be_successful }
        it { response.should redirect_to new_user_session_path }
      end

    end

  end