require 'sinatra'
require 'mysql2'
require 'aws-sdk'
require_relative 'phone_book.rb'
require_relative 'local_ENV.rb'
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
  client.query("INSERT INTO `user`(id, username, password) VALUES(UUID(), '#{username}', '#{password}')")
  x = client.query("SELECT `id` FROM `user` WHERE username = '#{username}' AND password = '#{password}'")
  x.each do |c|
    arr << c['id']
  end
  session[:user_id] = arr.join('')
  # client.query("INSERT INTO contacts() VALUES()" )
  redirect '/phonedash'

end 


get '/phoney2' do
  erb :phone_book1
end

post '/phoney2' do
  username = params[:username]
  password = params[:password]
  
  client.query("INSERT INTO `user`(id, username, password) VALUES(UUID(), '#{username}', '#{password}')")
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
  redirect '/'
end