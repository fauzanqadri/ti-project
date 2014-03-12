TiProject::Application.routes.draw do

  devise_for :users, :skip => [:sessions, :registrations, :password]
  devise_scope :user do
    authenticated :user do
      root to: "static_pages#index", as: :authenticated_root
      delete "/sign_out"  => "devise/sessions#destroy", as: :destroy_users_session
    end
    unauthenticated :user do
      root to: "devise/sessions#new", as: :unauthenticated_root
      get "/sign_in" => "devise/sessions#new", as: :new_user_session
      post "/sign_in" => "devise/sessions#create", as: :user_session
    end
  end
  resources :staffs
  
  resources :lecturers do
    get '/search', action: "search", on: :collection
  end

  resources :students
  resources :concentrations, except: :show
  resources :departments, except: :show
  resources :faculties, except: :show
  resources :courses, only: :index

  resources :pkls, except: :index do
    resources :papers, except: [:edit, :update]
    resources :supervisors, except: [:edit, :update, :show] do
      post '/become_supervisor', action: "become_supervisor", on: :collection
      post 'approve', action: "approve", on: :member
    end
    resources :feedbacks, except: [:edit, :update, :show]
    resources :consultations, except: :show
  end

  resources :skripsis, except: :index do
    resources :papers, except: [:edit, :update]
    resources :supervisors, except: [:edit, :update, :show] do
      post '/become_supervisor', action: "become_supervisor", on: :collection
      post 'approve', action: "approve", on: :member
    end
    resources :feedbacks, except: [:edit, :update, :show]
    resources :consultations, except: :show
    resources :seminars, except: [:index, :destroy] do
      get "edit_department_director_approval", action: "edit_department_director_approval", on: :member
      put "edit_department_director_approval", action: "update_department_director_approval", on: :member
      # put ""
    end
    # resources :sidangs, only: [:create, :show]
    resources :sidangs, except: [:index, :destroy] do
      get "edit_department_director_approval", action: "edit_department_director_approval", on: :member
      put "edit_department_director_approval", action: "update_department_director_approval", on: :member
      resources :examiners, only: :destroy
    end
    resources :conferences, only: :index
    
  end
  
  resource :settings, only: [:show, :update]
  resources :assessments, except: :show
  get "/waiting_approval" => "supervisors#waiting_approval"
  # resources :conferences, except: [:new, :create, :show]
  resources :conference_logs, only: [:index] do
    put '/approve', action: 'approve', on: :member
  end
  # resources :examiners
  resources :surceases, only: :index do
    post '/approve', action: 'approve', on: :member
    post '/disapprove', action: 'disapprove', on: :member
  end
  
  resources :conferences, only: [:edit, :update]
  get '/unmanaged_conferences' => 'conferences#unmanaged_conferences'
  get '/published_courses' => 'static_pages#published_courses'
  get '/get_faculties' => 'static_pages#get_faculties'
  get '/get_departments/:faculty_id' => 'static_pages#get_departments'
  get '/get_concentrations/:department_id' => 'static_pages#get_concentrations'
  get '/profile' => 'static_pages#profile'
  put '/profile' => 'static_pages#update_profile'
  get '/account' => 'static_pages#account'
  put '/account' => 'static_pages#update_account'
  get '/password' => 'static_pages#password'
  put '/password' => 'static_pages#update_password'


  # devise_for :users
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
