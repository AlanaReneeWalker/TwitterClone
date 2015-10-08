require "sinatra"
require "sinatra/activerecord"
require "bundler/setup"
require "./models"

# set :database, "sqlite3:exercise-2.sqlite3"

get "/" do
	"Test DogCrimes website"
end

get "/signup" do
	erb :signup
end