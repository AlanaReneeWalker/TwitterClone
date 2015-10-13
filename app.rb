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
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end


get "/" do
	if session[:user_id]
  	@posts=Post.all
  	flash[:info] = "You've signed in successfully."
  else
  	flash[:alert] = "You need to log in  or sign up to see a full website."
  	redirect "/signin"
  end
  erb :index
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
  redirect "/signin"
end


get "/signin" do
  erb :signin
end


post "/signin" do
	@user=User.where(username: params[:username]).last
  if (@user && @user.password == params[:password])

    session[:user_id] = @user.id
    current_user
    flash[:info] = "You've been signed in successfully."  
    redirect "/" 
  else     
	flash[:alert] = "Wrong username and/or password."
	redirect "/signin" 
  end
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

get "/posts" do
	@posts=Post.where(user_id: current_user.id)
	erb :posts
end


get "/posts/:user_id" do
	@posts = Post.where(user_id: params[:user_id])
	@user=User.where(user_id: param[:user_id])
	erb :posts
end

get "/connections" do

	@usersFollowee= current_user.followees
	@usersFollowers= current_user.followers
	erb :connections
end


get "/users/:followee_id/follow" do
  Follow.create(follower_id: session[:user_id], followee_id: params[:followee_id])
  redirect "/posts/:post.user_id"
end

get "/users/:followee_id/unfollow" do
  @follow = Follow.where(follower_id: session[:user_id], followee_id: params[:followee_id]).first
  @follow.destroy
  redirect "/posts/:post.user_id"
end


get "/profile" do
	erb :profile
end

post "/edit" do
    @user = current_user.update(params[:user])
    redirect "/profile"
end


post "/make-post" do
	@post = Post.create(subject: params[:subject],
						body: params[:body],
						user_id: params[:user_id],
						time: params[:time])
	redirect "/posts"
end


def deleteUser
	User.destroy(current_user.id)
end


post '/delete' do
	deleteUser
	session[:user_id]=nil
    redirect "/"
end