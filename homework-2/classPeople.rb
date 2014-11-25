class People
   def register(username, password, email, firstName, lastName)
      db.insert([username, email, firstName, lastName], 'users')
   end
   def login(username, password)
      user = db.select([username, password], 'users')
      @user = user
   end
   def checkLogin()
      @user
   end
   def delete(id)
      db.delete(id, 'users')
   end
end




Object1 = People.new()
if (Object1.checkLogin()) ....
else ....



Object2 = People.new()
Object2.login(username, password)



Object3 = People.new()
Object3.register(username, password, email, firstName, lastName)