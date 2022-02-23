Rails.application.routes.draw do
  #admin_rep_show, admin_student_show, admin_rep_finish, admin
  #get 'students/admin_show', to: 'students#admin_show', as: 'admin_show_student'
  #get 'representatives/admin_show', to: 'representatives#admin_show'
  get 'representatives/finish', to: 'representatives#finish', as: 'finish_representative'
  get 'admin', to: 'students#admin', as: 'admin'

  resources :representatives do
    member do
      get :admin_show
    end
  end

  resources :students do
    member do
      get :admin_show
    end
  end

  resources :representatives
  resources :students
  resources :universities
  root "representatives#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
