Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/posts' => 'posts#all'

      resources :posts do
        collection do
          get :tree
        end
        member do
          get :products
        end
      end
    end
  end
end