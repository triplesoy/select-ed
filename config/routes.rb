Rails.application.routes.draw do
  root to: 'communities#index'
  devise_for :users

  resources :communities do
    resources :community_join_requests, only: [:index, :create, :update, :destroy]
    resources :community_users, only: [:index, :create, :update, :destroy]
    resources :events do
      resources :events_rsvp, only: [:index, :new, :create, :destroy]
      resources :tickets, only: [:index, :show, :create]
    end
  end

get "my_communities", to: "communities#my_communities", as: :my_communities
get "my_events", to: "events#my_events", as: :my_events
get "events_owned", to: "events#events_owned", as: :events_owned
end
