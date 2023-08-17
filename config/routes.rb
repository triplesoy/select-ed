Rails.application.routes.draw do
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'communities#index'
  devise_for :users
  require 'sidekiq/web'

  resources :communities do
    resources :community_join_requests, only: [:index, :create, :update, :destroy]
    resources :community_users, only: [:index, :create, :update, :destroy]
    resources :events, except: [:index] do
      resources :tickets, only: [:index, :show, :create, :new, :destroy]
    end
  end

resources :tickets, only: [:edit, :update] do
  resources :user_tickets, only: [:index, :show, :new, :create, :destroy, :update]
end

  patch "make-moderator", to: "community_users#make_moderator", as: :make_moderator
  patch "remove-moderator", to: "community_users#remove_moderator", as: :remove_moderator
  patch "notifications/read_all", to: "notifications#mark_all_as_read", as: :read_all



  # patch '/tickets/:id/edit', to: 'tickets#update', as: 'edit_ticket'


  # post "create/user_ticket", to: "Usertickets#create", as: :create_user_ticket
  get "my_communities", to: "communities#my_communities", as: :my_communities
  get "my_events", to: "events#my_events", as: :my_events
  get "my_tickets", to: "user_tickets#my_user_tickets", as: :my_tickets
  get "events_owned", to: "events#events_owned", as: :events_owned
  get "communities/:id/dashboard", to: "communities#dashboard", as: :dashboard

  get "communities/:community_id/events/:id/event_dashboard", to: "events#event_dashboard", as: :event_dashboard

  get "user_tickets/:id/confirmation", to: "user_tickets#confirmation", as: :confirmation_page
  get "user_tickets/:id/validation", to: "user_tickets#validation", as: :validation_page
  get "new_scan", to: "user_tickets#new_scan", as: :new_scan

  get "communities/:community_id/user_history/:id", to: "community_users#user_history", as: :user_history

  get "tickets/:id/redeem", to: "tickets#redeem", as: :redeem_ticket

  delete "events/photos/:id", to: "events#destroy_event_photo", as: :destroy_event_photo
  delete "communities/photos/:id", to: "communities#destroy_community_photo", as: :destroy_community_photo

  mount Sidekiq::Web => '/sidekiq'


end
