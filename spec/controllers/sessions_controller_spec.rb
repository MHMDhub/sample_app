require 'spec_helper'

describe SessionsController do
  render_views  #we do 'render_views' everytime we use have_selector tag
  
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign in")
    end
  
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :email => "", :password => "" }
      end
      
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have a right title" do
        post :create, :session => @attr
        response.should have_selector('title', :content => "Sign in")
      end
      
      it "should have an error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "success" do
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      
      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
      
    end
  end
  
  #Next we would create the destroy method is seesions_controller, but before that we need to create a test
  describe "DELETE 'destroy'" do
    it "should sign a user out" do
        test_sign_in(Factory(:user))  #defined in spec_helper so that its' not available everywhere
        delete :destroy
        controller.should_not be_signed_in
        response.should redirect_to(root_path)  #we could have created a separate test for this redirect as in the above "should redirect...", and many people feel strongly about that, but it seems like an overkill in this instance 
    end
  end
  
  
  
end


 