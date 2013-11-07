Dashboard::Application.routes.draw do
  resources :callouts
  resources :videos
  resources :concepts
  resources :activities
  resources :sections, only: [:new, :create, :edit, :update, :destroy]

  devise_for :users, controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  post '/signup_check/username', to: 'home#check_username'

  root :to => "home#index"
  get '/home_insert', to: 'home#home_insert'

  post '/locale', to: 'home#set_locale', as: 'locale'

  resources :games do
    resources :levels
  end

  resources :scripts, only: [], path: '/s/' do
    resources :script_levels, as: :levels, only: [:show], path: "/level"
  end

  get '/hoc/reset', to: 'script_levels#show', script_id: Script::HOC_ID, reset:true, as: 'hoc_reset'
  get '/hoc/:chapter', to: 'script_levels#show', script_id: Script::HOC_ID, as: 'hoc_chapter'

  get '/k8intro/:chapter', to: 'script_levels#show', script_id: Script::TWENTY_HOUR_ID, as: 'k8intro_chapter'

  resources :followers, only: [:new, :create, :index]
  get '/followers/:teacher_user_id/accept', to: 'followers#accept', as: 'follower_accept'
  post '/followers/create_student', to: 'followers#create_student', as: 'create_student'
  get '/followers/manage', to: 'followers#manage', as: 'manage_followers'

  # change student password
  get '/followers/change_password/:user_id', to: 'followers#student_edit_password', as: 'student_edit_password'
  post '/followers/save_password', to: 'followers#student_update_password', as: 'student_update_password'

  post '/followers/add_to_section', to: 'followers#add_to_section', as: 'add_to_section'
  get '/join(/:section_code)', to: 'followers#student_user_new', as: 'student_user_new'
  post '/join/:section_code', to: 'followers#student_register', as: 'student_register'

  post '/milestone/:user_id/:script_level_id', :to => 'activities#milestone', :as => 'milestone'

  get '/admin/usage', to: 'reports#all_usage', as: 'all_usage'
  get '/stats/usage/:user_id', to: 'reports#usage', as: 'usage'
  get '/stats/students', to: 'reports#students', as: 'student_usage'
  get '/stats/:user_id', to: 'reports#user_stats', as: 'user_stats'
  get '/stats/level/:level_id', to: 'reports#level_stats', as: 'level_stats'
  get '/popup/stats', to: 'reports#header_stats', as: 'header_stats'

  get '/notes/:key', to: 'notes#index'

  # special redirect links
  get '/billg', to: redirect('/s/1/level/13')
  get '/zuck', to: redirect('/s/1/level/5')

  get '/api/user_menu', to: 'api#user_menu', as: 'user_menu'

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
