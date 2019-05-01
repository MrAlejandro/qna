Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    delete 'delete_file/:file_id', action: :delete_file, as: :delete_file_from, on: :member

    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
        delete 'delete_file/:file_id', action: :delete_file, as: :delete_file_from
      end
    end
  end
end
