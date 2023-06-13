Rails.application.routes.draw do
  get 'events_rsvp/index'
  get 'events_rsvp/show'
  get 'events_rsvp/new'
  get 'events_rsvp/create'
  get 'events_rsvp/edit'
  get 'events_rsvp/update'
  get 'events_rsvp/destroy'
  get 'community_users/index'
  get 'community_users/show'
  get 'community_users/new'
  get 'community_users/create'
  get 'community_users/edit'
  get 'community_users/update'
  get 'community_users/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
