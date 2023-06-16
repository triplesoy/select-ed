Rails.application.routes.draw do
  mount RailsAdmin::Engine => '//admin', as: 'rails_admin'
  root to: 'communities#index'
  devise_for :users

  resources :communities do
    resources :community_join_requests, only: [:index, :create, :update, :destroy]
    resources :community_users, only: [:index, :create, :update, :destroy]
    resources :events, except: [:index] do
      resources :user_tickets, only: [:index, :create, :new, :destroy]
      resources :tickets, only: [:index, :show, :create, :new, :destroy]
    end
  end

#post "create/user_ticket", to: "Usertickets#create", as: :create_user_ticket
get "my_communities", to: "communities#my_communities", as: :my_communities
get "my_events", to: "events#my_events", as: :my_events
get "events_owned", to: "events#events_owned", as: :events_owned
get "communities/:id/dashboard", to: "communities#dashboard", as: :dashboard

end
