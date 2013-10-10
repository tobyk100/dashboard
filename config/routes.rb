Dashboard::Application.routes.draw do
  resources :callouts
  resources :videos
  resources :concepts
  resources :activities
  resources :sections, only: [:new, :create, :edit, :update, :destroy]

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  root :to => "home#index"

  resources :games do
    resources :levels
  end

  resources :scripts, only: [], path: '/s/' do
    resources :script_levels, as: :levels, only: [:show], path: "/level"
  end

  resources :followers, only: [:new, :create, :index]
  get '/followers/:teacher_user_id/accept', to: 'followers#accept', as: 'follower_accept'
  post '/followers/create_student', to: 'followers#create_student', as: 'create_student'
  get '/followers/manage', to: 'followers#manage', as: 'manage_followers'
  post '/followers/add_to_section', to: 'followers#add_to_section', as: 'add_to_section'

  post '/milestone/:user_id/:script_level_id', :to => 'activities#milestone', :as => 'milestone'

  get '/admin/usage', to: 'reports#all_usage', as: 'all_usage'
  get '/stats/usage/:user_id', to: 'reports#usage', as: 'usage'
  get '/stats/students', to: 'reports#students', as: 'student_usage'
  get '/stats/:user_id', to: 'reports#user_stats', as: 'user_stats'
  get '/stats/level/:level_id', to: 'reports#level_stats', as: 'level_stats'
  get '/popup/stats', to: 'reports#header_stats', as: 'header_stats'

  # special redirect links
  get '/billg', to: redirect('/s/1/level/13')
  get '/zuck', to: redirect('/s/1/level/5')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
