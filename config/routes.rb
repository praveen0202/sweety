Rails.application.routes.draw do
  devise_for :users

  resource :blood_glucose_levels, only: [:index, :new, :create]

  get '/search' => "blood_glucose_levels#index"

  root to: 'blood_glucose_levels#index'
end
