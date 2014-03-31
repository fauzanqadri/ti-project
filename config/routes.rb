require 'sidekiq/web'
TiProject::Application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
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

  resources :staffs do
    post 'reset_password', action: "reset_password", on: :member
  end
  
  resources :lecturers do
    get '/search', action: "search", on: :collection
    post 'reset_password', action: "reset_password", on: :member
  end

  resources :students do
    post 'reset_password', action: "reset_password", on: :member
  end
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
    resources :reports
    resources :pkl_assessments, only: :index
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
    end

    resources :sidangs, except: [:index, :destroy] do
      get "edit_department_director_approval", action: "edit_department_director_approval", on: :member
      put "edit_department_director_approval", action: "update_department_director_approval", on: :member
      resources :examiners, only: :destroy
    end
    resources :conferences, only: :index
    resources :reports
    
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
  get '/conferences_report' => 'conferences#conferences_report'
  post '/scheduled_conferences_report' => 'conferences#scheduled_conferences_report'
  get 'show_conferences_report' => 'conferences#show_conferences_report'
  get '/published_courses' => 'static_pages#published_courses'
  get '/get_faculties' => 'static_pages#get_faculties'
  get '/get_departments/:faculty_id' => 'static_pages#get_departments'
  get '/get_concentrations/:department_id' => 'static_pages#get_concentrations'
  get '/avatar/:id/:style' => 'static_pages#avatar', as: :avatar
  get '/profile' => 'static_pages#profile'
  put '/profile' => 'static_pages#update_profile'
  get '/account' => 'static_pages#account'
  put '/account' => 'static_pages#update_account'
  get '/password' => 'static_pages#password'
  put '/password' => 'static_pages#update_password'

  get '/student_help' => 'static_pages#student_help'
  get '/lecturer_help' => 'static_pages#lecturer_help'
  get '/staff_help' => 'static_pages#staff_help'
  get '/admin_help' => 'static_pages#admin_help'

  resources :imports, except: [:show, :edit, :update] do
    post '/download', action: 'download', on: :member
    post '/populate', action: 'populate', on: :member
  end

  post 'versions/:id/revert' => "versions#revert", as: "revert_version"
  resources :pkl_assessments

  resources :posts do
    post "/publish" => "posts#publish", as: :publish_post, on: :member
  end

  get '/news' => "posts#news", as: :news

end
