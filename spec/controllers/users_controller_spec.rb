require 'spec_helper'
#had to force load the factory definitions
require 'factory_girl'
Factory.find_definitions  



describe UsersController do
  render_views

   
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


end
