# frozen_string_literal: true

#                            Prefix Verb   URI Pattern                            Controller#Action
#                  new_user_session GET    /users/sign_in(.:format)               devise/sessions#new
#                      user_session POST   /users/sign_in(.:format)               devise/sessions#create
#              destroy_user_session DELETE /users/sign_out(.:format)              devise/sessions#destroy
#                 new_user_password GET    /users/password/new(.:format)          devise/passwords#new
#                edit_user_password GET    /users/password/edit(.:format)         devise/passwords#edit
#                     user_password PATCH  /users/password(.:format)              devise/passwords#update
#                                   PUT    /users/password(.:format)              devise/passwords#update
#                                   POST   /users/password(.:format)              devise/passwords#create
#          cancel_user_registration GET    /users/cancel(.:format)                devise/registrations#cancel
#             new_user_registration GET    /users/sign_up(.:format)               devise/registrations#new
#            edit_user_registration GET    /users/edit(.:format)                  devise/registrations#edit
#                 user_registration PATCH  /users(.:format)                       devise/registrations#update
#                                   PUT    /users(.:format)                       devise/registrations#update
#                                   DELETE /users(.:format)                       devise/registrations#destroy
#                                   POST   /users(.:format)                       devise/registrations#create
#                              root GET    /                                      static_pages#login
#                static_pages_login GET    /static_pages/login(.:format)          static_pages#login
#                 static_pages_user GET    /static_pages/user(.:format)           static_pages#user
#         line_message_api_callback POST   /line_message_api/callback(.:format)   line_message_api#callback
#              line_login_api_login GET    /line_login_api/login(.:format)        line_login_api#login
#           line_login_api_callback GET    /line_login_api/callback(.:format)     line_login_api#callback
#  turbo_recede_historical_location GET    /recede_historical_location(.:format)  turbo/native/navigation#recede
#  turbo_resume_historical_location GET    /resume_historical_location(.:format)  turbo/native/navigation#resume
# turbo_refresh_historical_location GET    /refresh_historical_location(.:format) turbo/native/navigation#refresh

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users

  # Defines the root path route ("/")
  root 'static_pages#login'
  get 'static_pages/login'
  get 'static_pages/user'
  post 'line_message_api/callback', to: 'line_message_api#callback'
  get 'line_login_api/login', to: 'line_login_api#login'
  get 'line_login_api/callback', to: 'line_login_api#callback'
end
