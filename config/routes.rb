Rails.application.routes.draw do
  root 'top#index'

  post '/account' => 'account#create', as: :account
  get '/account/edit' => 'account#edit', as: :edit_account
  patch '/account' => 'account#update'
#   get '/accounts/new/:token' => 'accounts#new', as: :signup

  get '/sign/in/:token' => 'sign#in', as: :signin
  get '/sign/out' => 'sign#out', as: :signout
  get '/sign/up/:token' => 'sign#up', as: :signup
  post '/sign/send_email' => 'sign#send_email', as: :send_email_sign

  post '/photos' => 'photos#create'
  get '/photos/new' => 'photos#new', as: :new_photos
  delete '/photos/:key' => 'photos#destroy', as: :photo
  get '/photos/:key/download' => 'photos#download', as: :download_photo

  get '/streams' => 'streams#index'
  post '/streams' => 'streams#create'
  get '/streams/:key' => 'streams#show', as: :stream
  get '/streams/:key/edit' => 'streams#edit', as: :edit_stream
  post '/streams/:key/invite' => 'streams#invite', as: :invite_stream
  patch '/streams/:key' => 'streams#update'
  delete '/streams/:key' => 'streams#destroy'

  get '/streams/:stream_key/photos/:photo_key' => 'photo_streams#show', as: :photo_stream
  post '/streams/:stream_key/photos/:photo_key' => 'photo_streams#create'
  delete '/streams/:stream_key/photos/:photo_key' => 'photo_streams#destroy'

  post '/streams/:stream_key/accounts/' => 'account_streams#create', as: :accounts_stream
  patch '/streams/:stream_key/accounts/:account_name' => 'account_streams#update', as: :account_stream
  delete '/streams/:stream_key/accounts/:account_name' => 'account_streams#destroy'
end
