Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :api, defaults: { format: :json }  do
      resources :places, only: [ :index ], path: '/places/search'
   end
 end

