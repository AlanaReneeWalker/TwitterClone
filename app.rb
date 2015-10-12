require "sinatra"
require "sinatra/activerecord"
require "bundler/setup"
require "rack-flash" 
require "sinatra/content_for"
require "sinatra/contrib/all"
require "./models"

set :database, "sqlite3:DogCrimes.sqlite3"
enable :sessions
set :sessions, true
use Rack::Flash, sweep: true

def current_user
	if session [:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get "/" do
  @posts=Post.all
  erb :index
end

get "/users/:users.id/posts" do
	@posts = Post.where(user_id: session[:user_id])
	erb :posts
end

get "/users/:user.id/connections" do
	@usersFollowee= current_user.followees
	@usersFollowers= current_user.followers
	erb :connections
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
  flash[:info] = "Please sign in using your new username and password."
  redirect "/sign_in"
end


get "/signin" do
  erb :signin
end


post "/signin" do
	@user=User.where(username: params[:username]).first
  if (@user && @user.password == params[:password])
    session[:user_id] = @user.id
    flash[:info] = "You've been signed in successfully."  
    redirect "/" 
  else     
	flash[:alert] = "Wrong username and/or password."
	redirect "/signin" 
  end
end


post "/make-post" do
	@post = Post.create(subject: params[:subject],
						body: params[:body],
						user_id: params[:user_id],
						time: params[:time])
	redirect "/users/:users.id/posts"
end


get "/logout" do
	 if session[:user_id]
		@user = User.find(session[:user_id])
		session[:user_id] = nil
		redirect '/'
	 else
	 	redirect '/'
	 end
end