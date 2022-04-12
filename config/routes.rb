Rails.application.routes.draw do
  resources :authorizeds
  root to: 'representatives#user_new'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  # specific definitions go first or else get overwritten by default definitions
  get 'representatives/:id/students/user_new/', to: 'students#user_new', as: 'user_new_student' #pass representative id to new student form
  get 'admin', to: 'students#admin', as: 'admin' # admin home page in student folder for now
  get 'admin/update_deadline', to: 'students#update_deadline', as: 'update_deadline'
  get 'admin/help', to: 'students#admin_help', as: 'admin_help'
  get 'help', to: 'students#user_help', as: 'user_help'

  # add new functions/pages to separate user and admin views
  resources :representatives do
    member do
      get :user_show
      get :user_edit
      patch :user_update
      get :finish
      get :delete
    end
    collection do
      get :user_new
      post :user_create
      get :clear_all
      post :destroy_all
    end
  end

  resources :students do
    resources :responses do
	  member do
	    get :user_edit
	    patch :user_update
	  end
      collection do
        get :clear_all
        post :destroy_all
      end
      member do
        get :delete
      end
    end
    member do
      get :user_show
      get :user_edit
      patch :user_update
      post :user_destroy
      get :delete
      get :user_delete
    end
    collection do
      post :user_create
      get :export, path: 'export/student.csv' # export button
      get :clear_all
      post :destroy_all
    end
  end

  # default definitions and root
  resources :universities do
    collection do
      get :update_max
      get :change_all_max
      get :clear_all
      post :destroy_all
      get :reset_all
      post :reset
    end
    member do
      get :delete
    end
  end


  resources :dashboards do
    collection do
      get :deadline
    end
  end

  # default definitions and root
  resources :responses
  resources :questions do
	  resources :answers do
      member do
        get :delete
      end
    end
    collection do
      get :clear_all
      post :destroy_all
    end
    member do
      get :delete
    end
  end
  
  resources :answers do
    member do
      get :show
      get :edit
      patch :update
      post :destroy
      get :delete
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
