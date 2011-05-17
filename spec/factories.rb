Factory.define :user do |user|
    user.name                  "Michael Hartl"
    user.email                 "mhartl@example.com"
    user.password              "foobar"
    user.password_confirmation "foobar"
end


# FactoryGirl.define :user do 
#   factory :user do
#     name                  "Michael Hartl"
#     email                 "mhartl@example.com"
#     password              "foobar"
#     password_confirmation "foobar"
#   end
#end  