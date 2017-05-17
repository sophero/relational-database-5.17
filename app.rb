require 'sinatra'
require 'sinatra/activerecord'

set :database, 'sqlite3:relationaldb.sqlite3'
set :sessions, true

require './models'

get '/' do
    p session
    if session[:user_id]
        p session
        @user = User.find(session[:user_id])
        @blogs = @user.blogs
        p @user
        p @blogs
    end
    erb :home
end

get '/sign_up' do
    erb :sign_up
end

post '/create_user' do
    user = User.create(username: params[:username], password: params[:password])
    session[:user_id] = user.id
    redirect '/'
end

post '/login' do
    user = User.where(username: params[:username]).first
    if user.password == params[:password]
        p 'successful login'
        session[:user_id] = user.id
        p session[:user_id]
        if session[:user_id]
            p 'this works'
        end
    end
    redirect '/'
end

get '/read_post' do
    @post = Blog.find(params[:post_id])
    erb :read_post
end

get '/create_post' do
    erb :create_post
end

post '/create_post' do
    Blog.create(title: params[:title], category: params[:category], content: params[:content], user_id: session[:user_id])
    redirect '/'
end

#
# get '/profile' do
#     @user = User.find(session[:user_id])
#     @blogs = @user.blogs
#     erb :blogs
# end
