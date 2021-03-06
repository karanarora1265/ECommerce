Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions, registrations: :registrations},
                       path_names: { sign_in: :login }
  end
  resources :brands
  resources :companies
  resources :brand_managers

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
