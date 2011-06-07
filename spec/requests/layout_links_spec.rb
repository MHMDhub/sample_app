require 'spec_helper'

describe "LayoutLinks" do
  it "shoud have a Home page at '/'" do
      get '/'
      response.should have_selector("title", :content => "Home")
    end

    it "shoud have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector("title", :content => "Contact")
    end

    it "shoud have a About page at '/about'" do
      get '/about'
      response.should have_selector("title", :content => "About")
    end


    it "shoud have a Help page at '/help'" do
      get '/help'
      response.should have_selector("title", :content => "Help")
    end
    
    it "should have a signup page at '/signup'" do
      get '/signup'
      response.should have_selector('title', :content => "Sign up")
    end
    
      it "should have a signin page at '/signin'" do
        get '/signin'
        response.should have_selector('title', :content => "Sign in")
      end
  
    it "should have the right links on the layout" do
      #this is webrat/capybara syntax that allows navigation w/o browser
      visit root_path
      response.should have_selector('title', :content => "Home")
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      click_link "Home"
      response.should have_selector('title', :content => "Home")
      click_link "Sign up now!"
      response.should have_selector('title', :content => "Sign up")
      #to test for the logo link
      response.should have_selector('a[href="/"]>img')
    end
end
