require 'pry'
class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do

    erb :'/registrations/signup'
  end

  #The post '/registrations' route is responsible for handling the POST 
  #request that is sent when a user hits 'submit' on the sign-up form. 
  #It will contain code that gets the new user's info from the params 
  #hash, creates a new user, signs them in, and then redirects them 
  #somewhere else.


  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id

    redirect '/users/home'
  end

  #The get '/sessions/login' route is responsible for rendering the login form.
  get '/sessions/login' do

    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

#The post '/sessions' route is responsible for receiving the POST request that 
#gets sent when a user hits 'submit' on the login form. This route contains code
# that grabs the user's info from the params hash, looks to match that info 
#against the existing entries in the user database, and, if a matching entry is 
#found, signs the user in.

  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

#The get '/sessions/logout' route is responsible for logging the user out by 
#clearing the session hash.
  
  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

#The get '/sessions/logout' route is responsible for logging the user out 
#by clearing the session hash.

  get '/users/home' do


    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
