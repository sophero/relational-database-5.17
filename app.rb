require 'sinatra'
require 'sinatra/activerecord'

set :database, 'sqlite3:relationaldb.sqlite3'
set :sessions, true

require './models'

get '/' do
    if session[:user_id]
        @user = User.find(session[:user_id])
        @blogs = @user.blogs
    end
    erb :home
end

get '/sign_up' do
    erb :sign_up
end

post '/login' do
    user = User.where(username: params[:username]).first
    if user.password == params[:password]
        session[:user_id] = user.id
        p 'successful login'
        p session
    end
    redirect '/'
end

get '/users' do
    @users = User.all
    erb :users
end

post '/create_user' do
    user = User.create(username: params[:username], password: params[:password])
    session[:user_id] = user.id
    redirect '/'
end

get '/profile/:id' do
    @user = User.find(params[:id])
    @blogs = @user.blogs
    erb :profile
end

get '/read_post/:id' do
    @post = Blog.find(params[:id])
    @comments = @post.comments
    erb :read_post
end

get '/create_post' do
    erb :create_post
end

post '/create_post' do
    Blog.create(title: params[:title], category: params[:category], content: params[:content], user_id: session[:user_id])
    redirect '/'
end

post '/create_comment' do
    user_id = session[:user_id]
    blog_id = params[:blog_id]
    Comment.create(user_id: user_id, blog_id: blog_id, content: params[:content])
    redirect "/read_post/#{blog_id}"
end

post '/logout' do
    session[:user_id] = nil
    redirect '/'
end
