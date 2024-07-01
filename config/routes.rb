Rails.application.routes.draw do
  devise_for :users
  resources :movies, only: [:index, :show] do
    resources :showtimes, only: [:show] do
      resources :bookings, only: [:create, :destroy]
    end
  end

  root 'movies#index'
end
