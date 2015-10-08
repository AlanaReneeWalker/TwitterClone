require "sinatra"
require "sinatra/activerecord"
require "bundler/setup"
require "./models"

set :database, "sqlite3:DogCrimes.sqlite3"


enable :sessions



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
  	 				  email: param[:email],
  	 				  username: param[:username],
  	 				  password: param[:password])
  session[:user_id] = @user.id
  redirect to "/users/:user_id"
end


get "/signin" do
  erb :signin
end


post "/signin" do
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "You've been signed in successfully."  
    redirect to "/users/:user_id" 
	else     
	flash[:alert] = "There was a problem signing you in."
  end
end
