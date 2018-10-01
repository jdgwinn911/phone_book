require 'sinatra'
require 'mysql2'
require 'sanitize'
require_relative 'phone_book.rb'
load 'local_ENV.rb' if File.exist?('local_ENV.rb')
enable :sessions

client = Mysql2::Client.new(:host => ENV['endpoint'], :username => ENV['username'], :password => ENV['password'], :database => ENV['db'])
#results = client.query("SELECT * FROM `phoneybook`")
get '/' do
  erb :phone_book
end

post '/phoney1' do
  username = params[:username]
  password = params[:password]
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

  client.query("INSERT INTO `user`(id, username, password) VALUES(UUID(),'#{mkusername}', AES_ENCRYPT('#{mkpassword}', UNHEX(SHA2('#{ENV['salt']}',512))))")
  redirect '/'
end

get '/phonedash' do
 
erb :phone_book_dash
end

post '/phonedash' do

  First_Name = params[:First_Name]
  First_Name = client.escape(First_Name)
  Last_Name = params[:Last_Name]
  Last_Name = client.escape(Last_Name)
 Street_Address = params[:Street_Address]
 Street_Address = client.escape(Street_Address)
  City = params[:City]
  City = client.escape(City)
  State = params[:State]
  State = client.escape(State)
  Phone_Number = params[:Phone_Number]
  Phone_Number = client.escape(Phone_Number)
  Zip = params[:Zip]
  Zip = client.escape(Zip)
  id = session[:user_id]
  id = client.escape(id)
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
