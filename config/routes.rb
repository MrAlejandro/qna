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

  concern :commentable do
    post :comment, on: :member
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: %i[create update destroy] do
      patch :best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
