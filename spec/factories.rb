Factory.define :user do |user|
   user.name                    "logan sease"
   user.email                   "lsease@gmail.com"
   user.password                "foobar"
   user.password_confirmation   "foobar"
   user.fb_user_id              6206197
end       

Factory.define :micropost do |mp|
   mp.content                    "content"
   mp.association                :user

end  

Factory.sequence :email do |n|
   "person-#{n}@example.com"
end