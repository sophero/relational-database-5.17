require 'sinatra'
require 'sinatra/activerecord'

set :database, 'sqlite3:relationaldb.sqlite3'

require './models'
