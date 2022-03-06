Rails.application.routes.draw do
  resources :responses
  resources :questions do
	resources :answers
  end
  resources :representatives
  resources :students do
	resources :responses
  end
  resources :universities
  root "representatives#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
