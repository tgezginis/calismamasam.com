class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  draw :api

  devise_for :users, :controllers => { registrations: 'users', omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  end
  get '/users/auth/github/callback' => 'omniauth_callbacks#github' # Fix for Github oauth

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root to: 'home#index'
  get '/' => 'home#index', as: :home
  get '/hakkinda' => 'posts#about', as: :about
  get '/kategoriler' => 'categories#index', as: :categories
  get '/kategori/:id' => 'categories#show', as: :category
  get '/galeri' => 'galleries#index', as: :galleries
  get '/galeri/yeni' => 'galleries#new', as: :new_gallery
  post '/galeri/yeni' => 'galleries#create', as: :create_gallery
  get '/galeri/:id/like/(:token)' => 'galleries#like', as: :like_gallery
  get '/galeri/:id/unlike/(:token)' => 'galleries#unlike', as: :unlike_gallery
  get '/galeri/:id' => 'galleries#show', as: :gallery
  get '/ara/:query' => 'searches#show', as: :search
  get '/istatistikler/(:id)/(:post_category_id)' => 'stats#index', as: :stats
  get '/ekipman/:id' => 'products#show', as: :product
  get '/ekipman/:id/vote' => 'products#vote', as: :vote_product
  get '/abone-ol' => 'subscribers#new', as: :new_subscriber
  post '/abone-ol' => 'subscribers#create', as: :create_subscriber
  get '/feed' => 'posts#feed', as: :feed, :format => 'rss'
  get '/profilim' => 'profiles#edit', as: :edit_profile
  get '/profilim/favori-ekipmanlar' => 'profiles#voted', as: :voted_products
  patch '/profilim' => 'profiles#update', as: :update_profile

  get '/:id/like/(:token)' => 'posts#like', as: :like_post
  get '/:id/unlike/(:token)' => 'posts#unlike', as: :unlike_post
  get '/:id' => 'posts#show', as: :post
end
