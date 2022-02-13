Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        scope module: :merchants do
          resources :items, only: [:index]
          get 'find', to: 'search#find', on: :collection
        end
      end

      resources :items do
        scope module: :items do
          resources :merchant, only: [:index]
          get 'find_all', to: 'search#find_all', on: :collection
        end
      end
    end
  end
end
