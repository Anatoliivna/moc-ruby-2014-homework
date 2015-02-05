require 'sinatra'
#require 'json'


use Rack::Lint

get '/' do
  "British Secret Service"
end

get '/about' do
  "The Secret Intelligence Service (SIS)"
end


post('/login') do
  if params[:username] == 'James' && params[:password] == '007'
    'Wellcome, Mr. Bond!'
  else
    'Error'
  end
end


  get '/years/:year' do |year|
    if year.to_i % 400 == 0
      'true'
    elsif year.to_i % 100 == 0
      'false'
    elsif year.to_i % 4 == 0
      'true'
    else
      'false'
    end
  end