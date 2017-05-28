Rails.application.routes.draw do
  namespace :v1 do
    resources :users, except: [:destroy] do
      resources :meetings, except: [:destroy]
    end
  end
end
