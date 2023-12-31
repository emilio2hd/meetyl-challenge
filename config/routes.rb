Rails.application.routes.draw do
  get 'invitation_recurrences/index'

  apipie

  namespace :v1 do
    resources :users, except: [:destroy] do
      resources :meetings, except: [:destroy] do
        member do
          post :invite
        end
      end

      resources :invitations do
        member do
          get :status, to: 'invitations#check_status'
          put :execute
        end
      end

      resources :invitation_recurrences, only: [:index]
    end

    get 'meetings/:id/:access_code', to: 'meetings#access', as: :meeting_access
  end

  root 'apipie/apipies#index'
end
