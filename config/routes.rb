Rails.application.routes.draw do
  namespace :v1 do
    resources :users, except: [:destroy]
  end
end
