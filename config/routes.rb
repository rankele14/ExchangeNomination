Rails.application.routes.draw do
  # specific definitions go first or else get overwritten by default definitions
  get 'representatives/user_new', to: 'representatives#user_new', as: 'user_new_representative'
  get 'universities/:id/students/user_new/', to: 'students#user_new', as: 'user_new_student' #pass university id to new student form
  get 'universities/:id/finish/', to: 'representatives#finish', as: 'finish' # finish page
  get 'admin', to: 'students#admin', as: 'admin' # admin home page in student folder for now
  post 'representative/user_create', to: 'representatives#user_create', as: 'ucreate_representatives'
  post 'universities/:id/students/user_create', to: 'students#user_create', as: 'ucreate_students'

  # add new functions/pages to separate user and admin views
  resources :representatives do
    member do
      get :user_show
      get :user_edit
    end
  end

  resources :students do
    member do
      get :user_show
      get :user_edit
      patch :user_update
      put :user_update
    end
  end

  # default definitions and root
  resources :universities
  resources :representatives
  resources :students
  root "representatives#user_new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
