require 'sinatra'
require 'mysql2'
require 'sanitize'
load 'local_ENV.rb' if File.exist?('local_ENV.rb')
enable :sessions

client = Mysql2::Client.new(:host => ENV['endpoint'], :username => ENV['username'], :password => ENV['password'], :database => ENV['db'], :port => ENV['port'])
#results = client.query("SELECT * FROM `phoneybook`")
get '/' do
  error = session[:error] || ""
  erb :phone_book, locals: {error: error}
end

post '/phoney1' do
  username = params[:username] || ""
  # username.gsub!(/[!@$%&"]/,'')
  password = params[:password] || ""
  # password.gsub!(/[!@%&$"]/,'')
  error = session[:error] || ""
  username = client.escape(username)
  password = client.escape(password)
  arr = []
  x = client.query("SELECT `id` FROM `user` WHERE username = '#{username}'  AND password = AES_ENCRYPT('#{password}', UNHEX(SHA2('#{ENV['salt']}',512)))")
  x.each do |c|
    arr << c['id']
    p c['id']
  end
  unless arr.length > 0
    session[:error] = "invalid username or password"
    redirect '/'
  else arr.length <= 0
   session[:error] = ""
  end
  session[:user_id] = arr.join('')
  redirect '/contacts'

end 


get '/phoney2' do
  erb :phone_book1
end

post '/phoney2' do
  mkusername = params[:mkusername] || ""
  mkpassword = params[:mkpassword] || ""
  mkusername = client.escape(mkusername)
  mkpassword = client.escape(mkpassword)
  m = client.query("SELECT `username` FROM user")
  m.each do |v|
  if v.has_value?(mkusername)
      redirect '/phoney2'
  end
end

  client.query("INSERT INTO `user`(id, username, password) VALUES(UUID(),'#{mkusername}', AES_ENCRYPT('#{mkpassword}', UNHEX(SHA2('#{ENV['salt']}',512))))")
  redirect '/'
end

get '/phonedash' do
 
erb :phone_book_dash
end

post '/phonedash' do

  First_Name = params[:First_Name].tr("\"", "")
  First_Name = client.escape(First_Name)
  Last_Name = params[:Last_Name].tr("\"", "")
  Last_Name = client.escape(Last_Name)
  Street_Address = params[:Street_Address].tr("\"", "")
  Street_Address = client.escape(Street_Address)
  City = params[:City].tr("\"", "")
  City = client.escape(City)
  State = params[:State].tr("\"", "")
  State = client.escape(State)
  Phone_Number = params[:Phone_Number].tr("\"", "")
  Phone_Number = client.escape(Phone_Number)
  Zip = params[:Zip].tr("\"", "")
  Zip = client.escape(Zip)
  id = session[:user_id]

  client.query("INSERT INTO `contacts`(First_Name, Last_Name, Phone_Number, Street_Address, City, State, Zip, owner) VALUES('#{First_Name}', '#{Last_Name}', '#{Phone_Number}', '#{Street_Address}', '#{City}', '#{State}', '#{Zip}', '#{id}')")
  redirect '/contacts'
end

get '/contacts' do
  contacts = []

 v = client.query("SELECT * FROM `contacts` WHERE owner = '#{session[:user_id]}'")
 v.each do |z|
  aray =[]
  aray << Sanitize.clean(z['First_Name'])
  aray << Sanitize.clean(z['Last_Name'])
  aray << Sanitize.clean(z['Phone_Number'])
  aray << Sanitize.clean(z['Street_Address'])
  aray << Sanitize.clean(z['City'])
  aray << Sanitize.clean(z['State'])
  aray << Sanitize.clean(z['Zip'])
  aray << z["id"]
  contacts << aray
 end
  erb :contacts_page, locals:{contacts: contacts || []}

end

post '/contacts' do
  redirect '/contacts'
end

post '/delete' do
  contact_id = params[:contact_id]
  client.query("DELETE FROM `contacts` WHERE `id` = '#{contact_id}'")
  redirect '/contacts'
end

post '/uupdate' do 
  puts "params are #{params}"
  First_Name = params[:First_Name].tr("\"", "")
  puts "before .escape #{First_Name}"
  First_Name = client.escape(First_Name)
  puts "first name is #{First_Name}"
  Last_Name = params[:Last_Name].tr("\"", "")
  Last_Name = client.escape(Last_Name)
 Street_Address = params[:Street_Address].tr("\"", "")
 Street_Address = client.escape(Street_Address)
  City = params[:City].tr("\"", "")
  City = client.escape(City)
  State = params[:State].tr("\"", "")
  State = client.escape(State)
  Phone_Number = params[:Phone_Number].tr("\"", "")
  Phone_Number = client.escape(Phone_Number)
  Zip = params[:Zip].tr("\"", "")
  Zip = client.escape(Zip)
  id = session[:user_id]
  contact_id = params[:contact_id]
  
    client.query("UPDATE `contacts` SET First_Name ='#{First_Name}', Last_Name ='#{Last_Name}', Phone_Number ='#{Phone_Number}', Street_Address ='#{Street_Address}', City ='#{City}', State ='#{State}', Zip ='#{Zip}' WHERE `id` = '#{contact_id}';")

  redirect '/contacts'
end

