require 'sinatra'
require 'mysql2'
require 'aws-sdk'
require_relative 'phone_book.rb'
# require_relative 'local_ENV.rb'
load 'local_ENV.rb' if File.exist?('local_ENV.rb')
enable :sessions

client = Mysql2::Client.new(:host => ENV['endpoint'], :username => ENV['username'], :password => ENV['password'], :database => ENV['db'])
#results = client.query("SELECT * FROM `phoneybook`")
get '/' do
  erb :phone_book
end

post '/phoney1' do
  # fname = params[:fname]
  # lname = params[:lname]
  # address = params[:address]
  # city = params[:city]
  # state = params[:state]
  # phone_number = params[:pnum]
  # zip = params[:zip]
  # password = params[:pw]


  username = params[:username]
  password = params[:password]
  passwordconfig = params[:passwordconfig]
  arr = []
  x = client.query("SELECT `id` FROM `user` WHERE username = '#{username}' AND password = '#{password}'")
  x.each do |c|
    arr << c['id']
  end
  unless arr.length > 0
    session[:error] = "invalid username or password"
    redirect '/'
  end
  session[:user_id] = arr.join('')
  # client.query("INSERT INTO contacts() VALUES()" )
  redirect '/phonedash'

end 


get '/phoney2' do
  erb :phone_book1
end

post '/phoney2' do
  mkusername = params[:mkusername]
  mkpassword = params[:mkpassword]

  client.query("INSERT INTO `user`(id, username, password) VALUES(UUID(), '#{mkusername}', '#{mkpassword}')")
  redirect '/'
end

get '/phonedash' do
 
erb :phone_book_dash
end

post '/phonedash' do

  First_Name = params[:First_Name]
  Last_Name = params[:Last_Name]
  Street_Address = params[:Street_Address]
  City = params[:City]
  State = params[:State]
  Phone_Number = params[:Phone_Number]
  Zip = params[:Zip]
  id = session[:user_id]
  client.query("INSERT INTO `contacts`(First_Name, Last_Name, Phone_Number, Street_Address, City, State, Zip, owner) VALUES('#{First_Name}', '#{Last_Name}', '#{Phone_Number}', '#{Street_Address}', '#{City}', '#{ State}', '#{Zip}', '#{id}')")
  redirect '/contacts'
end

get '/contacts' do
  contacts = []

 v = client.query("SELECT * FROM `contacts` WHERE owner = '#{session[:user_id]}'")
 v.each do |z|
  aray =[]
  aray << z['First_Name']
  aray << z['Last_Name']
  aray << z['Phone_Number']
  aray << z['Street_Address']
  aray << z['City']
  aray << z['State']
  aray << z['Zip']
  contacts << aray
 end
  erb :contacts_page, locals:{contacts: contacts || []}

end

post '/contacts' do
  redirect '/phonedash'
end