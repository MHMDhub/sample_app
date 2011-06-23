module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  #the followig two methods are a setter and getter methods, the same as attr_accessor used in the User model
  #the accessor is defined explicitly here
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
      # @current_user || user_from_remember_token  #or @current = @current_user || user_from_remember_token
      #because we are going to be using @current_user for many things, we don't want to hit the database everytime as the line above would do.
      #so the solution is the flowing line which would check if @current_user is nil it would assign it 'user_from_remember_token' which will hit the database, but the second time it's requested is will just return it without hiting the database again
       @current_user ||= user_from_remember_token      #or  @current = @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?   #bolean signed_in? is true when current_user is NOT nil
  end
  
  def sign_out
    cookies.delete(:remember_token)
    #self.current_user = nil     #We first had to used the full "self.current_user = nil" because for some reason "current_user = nil" did not work with the tests
    current_user = nil        #we can now use this without (self) after we reused the sign_in method in spec_helper...see comments in spec_helper
  end
    
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token) 
      #by adding the * we are unwrapping [user.id, user.salt],
      #if method add() takes two arguments add(1,2), trying add([1,2]) would generate an error,
      #but is we do add(*[1,2]), the * would unrapp one layer and add the element in the list, same as above     
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
