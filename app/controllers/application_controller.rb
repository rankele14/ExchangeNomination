class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, except: [:user_new, :user_show, :user_create, :finish, :user_edit, :user_update]
end
