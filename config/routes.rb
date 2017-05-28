Rails.application.routes.draw do
  namespace :v1 do
    resources :users, except: [:destroy] do
      resources :meetings, except: [:destroy] do
        member do
          post :invite
        end
      end
    end

    get 'meetings/:id/:access_code', to: 'meetings#access', as: :meeting_access
  end
end
