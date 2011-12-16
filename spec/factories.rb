Factory.define :user do |user|
   user.name                    "logan sease"
   user.email                   "lsease@gmail.com"
   user.password                "foobar"
   user.password_confirmation   "foobar"
end       

Factory.define :micropost do |mp|
   mp.content                    "content"
   mp.association                :user

end  

Factory.sequence :email do |n|
   "person-#{n}@example.com"
end