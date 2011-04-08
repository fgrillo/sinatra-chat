#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'erb'
require 'json'

enable :sessions

$users = Array.new
$msgs = Array.new

get '/' do
  erb :index
end

post '/signin' do
  user = params[:nick]
  if user != nil and user != ''
    session["logged"] = true
    session["nick"] = user
    session["last_msg"] = $msgs.size
    $users << user
    redirect '/chat'
  end
end

get '/chat' do
  if session["logged"] and $users.include?(session["nick"])
    @user_list = $users.map {|u| "#{u} | "}
    @msg_number = $msgs.size
    erb :chat
  else
    'Sorry, you are not logged in! <a href="/">Go to login</a>'
  end
end

get '/signout' do
  if session["logged"]
    session["logged"] = false
    $users.delete(session["nick"])
    "See ya!"
  else
    "You are not in dude!"
  end
end

get '/read' do
  if session["logged"] and $users.include?(session["nick"])
    index = params["last_msg"].to_f
    session["last_msg"] = $msgs.size
    teste = Hash.new()
    teste['msgsize'] = $msgs.size
    teste['msgs'] = $msgs.slice(index, ($msgs.size - index))
    return JSON.generate teste
  else
    "You are not in dude!"
  end
end

post '/post' do
  if session["logged"] and $users.include?(session["nick"])
    post_message(params["message"])
    "Message posted!"
  else
    "You are not in dude!"
  end

end

helpers do
  def post_message(message);
    $msgs << [session["nick"], message]
  end

  def partial(template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end

end
