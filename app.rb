require "sinatra"
require "sinatra/activerecord"
require "bundler/setup"
require 'rack-flash' 
require "sinatra/content_for"
require "sinatra/contrib/all"
require "./models"

set :database, "sqlite3:DogCrimes.sqlite3"
enable :sessions
set :sessions, true
use Rack::Flash, sweep: true



get "/users/:user_id" do
  if session[:user_id]
  	params[:user_id]
    @user = User.find(session[:user_id])
  end
  
  erb :profile
end


get "/signup" do
  erb :signup
end


post "/signup" do
  @user = User.create(fname: params[:fname], 
  	 				  lname: params[:lname], 
  	 				  email: params[:email],
  	 				  username: params[:username],
  	 				  password: params[:password])
  session[:user_id] = @user.id
  redirect "/users/#{@user.id}"
end

get "/signin" do
  erb :signin
end


post "/signin" do
	@user=User.where(username: params[:username]).last
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "You've been signed in successfully."  
    redirect "/users/#{@user.id}" 
  else     
	flash[:alert] = "Wrong username and/or password."
	redirect "/signin" 
  end
end
