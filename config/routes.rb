Rails.application.routes.draw do
  # specific definitions go first or else get overwritten by default definitions
  get 'representatives/user_new', to: 'representatives#user_new', as: 'user_new_representative'
  get 'students/user_new', to: 'students#user_new', as: 'user_new_student'
  get 'representatives/finish', to: 'representatives#finish', as: 'finish_representative' # finish page
  get 'admin', to: 'students#admin', as: 'admin' # admin home page in student folder for now
  post 'user_create1', to: 'representatives#user_create', as: 'ucreate_representatives'
  post 'user_create2', to: 'students#user_create', as: 'ucreate_students'

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
    end
  end

  # default definitions and root
  resources :representatives
  resources :students
  resources :universities
  root "representatives#user_new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
