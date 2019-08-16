require 'sinatra'

class ApplicationController < Sinatra::Base
	configure do
  	set :views, "src/views"
  	set :public_dir, "public"
  end
end
