Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
  resources :attachments, only: %i[destroy]

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create

    resources :answers, concerns: :votable, shallow: true, only: %i[create update destroy] do
      resources :comments, only: :create
      patch :best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
