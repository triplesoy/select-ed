Rails.application.routes.draw do
  get 'community_join_request/index'
  get 'community_join_request/show'
  get 'community_join_request/new'
  get 'community_join_request/create'
  get 'community_join_request/edit'
  get 'community_join_request/update'
  get 'community_join_request/destroy'
  devise_for :users

  resources :communities do
    resources :community_join_requests, only: [:index, :update, :destroy]
    resources :community_users, only: [:index, :create, :update, :destroy]
    resources :events do
      resources :events_rsvp, only: [:index, :create, :destroy]
      resources :tickets, only: [:index, :show, :create]
    end
  end

  root to: 'communities#index'
end
