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

get "/posts" do
	@posts=Post.where(user_id: session[:user_id])
	@user = current_user
	erb :posts
end


get "/posts/:user_id" do
	@posts = Post.where(user_id: params[:user_id])
	@user = User.where(id: params[:user_id]).last
	erb :posts
end

get "/connections" do

	
	erb :connections
end

def followApp(params)
	@follower=params[:follower_id].to_i
    if @follower != current_user.id 
        Follow.create(follower_id: @follower, followee_id: current_user.id)
    end
end    

post "/follow" do
	   followApp(params)
       redirect "/connections"
end


get "/profile" do
	erb :profile
end

post "/edit" do
    @user = current_user.update(params[:user])
    redirect "/profile"
end


post "/make-post" do
	time=Time.now
	@post = Post.new(subject: params[:subject],
						body: params[:body],
						time: "#{time.year}-#{time.month}-#{time.day} [#{time.hour}:#{time.min}]")

	@post.user_id = current_user.id
	if @post.save
		redirect "/posts"
	else 
		redirect "/posts"	
	end
end


def deleteUser
	User.destroy(current_user.id)
end


post '/delete' do
	deleteUser
	session[:user_id]=nil
    redirect "/"
end

