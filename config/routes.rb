Rails.application.routes.draw do
  root to: 'communities#index'
  devise_for :users

  resources :communities do
    resources :community_join_requests, only: [:index, :update, :destroy]
    resources :community_users, only: [:index, :create, :update, :destroy]
    resources :events do
      resources :events_rsvp, only: [:index, :create, :destroy]
      resources :tickets, only: [:index, :show, :create]
    end
  end

end
