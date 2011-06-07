require 'spec_helper'
#had to force load the factory definitions
require 'factory_girl'
Factory.find_definitions  



describe UsersController do
  render_views  #we do 'render_views' everytime we use have_selector tag

   
    describe "GET 'show'" do
                
          before(:each) do
             @user = Factory(:user)  #Instead of passing it a hash with initialization values as in [Factory(:user, :password => "mypassword", :password_confirmation => "mypassword")], it by default uses those in Factories.rb
          end  
          it "should be successful" do
             get :show, :id => @user  #we don't need to do this @user.id since rails is permissive and understand that implicitly
             response.should be_success
          end
          
          it "should find the right user" do
            get :show, :id => @user
            assigns(:user).should == @user  
          end
      
          #tests for the user show page
          it "should have the right title" do
            get :show, :id => @user
            response.should have_selector('title', :content => @user.name)
          end
    
          it "should have the user's name" do
            get :show, :id => @user
            response.should have_selector('h1', :content => @user.name)
          end
        
          it "should have a profile image" do
            get :show, :id => @user
            response.should have_selector('h1>img', :class => "gravatar")
          end

          it "should have the right URL" do
            get :show, :id => @user
            response.should have_selector('td>a', :content => user_path(@user),
                                                  :href    => user_path(@user))
          end
    end
    
    describe "GET 'new'" do
          
          it "should be successful" do
            get :new
            response.should be_success
          end
        
          it "should have the right title" do
            get :new
            response.should have_selector('title', :content => "Sign up")
          end
   end
   
   describe "POST 'create'" do
          describe "failure" do
            before(:each) do
              @attr = {:name => "", :email => "", :password => "",
                       :password_confirmation => ""  }
            end
            
            it "should have the right title" do
              post :create, :user => @attr
              response.should have_selector('title', :content => "Sign up")
            end
            
            it "should render the 'new' page" do
              post :create, :user => @attr
              response.should render_template('new')
            end
            
            it "should not create a user" do
            #this is tricky, because we want to post to the create action with invalid user attributes and have it not create a user in the database...the way we're going to achieve that is by using a lambda block
              lambda do
                post :create, :user => @attr
              end.should_not change(User, :count)
            end
          end
          
          describe "success" do
            before(:each) do
              @attr = {:name => "New User", :email => "user@example.com", :password => "foobar",
                       :password_confirmation => "foobar"  }
            end
          
            it "should create a user" do
              lambda do
                post :create, :user => @attr
              end.should change(User, :count).by(1)
            end
          
            it "should redirect to the user show page" do
              post :create, :user => @attr
              response.should redirect_to(user_path(assigns(:user)))
            end
            
            it "should a welcome message" do
              post :create, :user => @attr
              flash[:success].should =~ /welcome to the sample app/i
            end
          
          end
   end
end
