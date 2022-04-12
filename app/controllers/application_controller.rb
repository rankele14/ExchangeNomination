class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, except: [:user_new, :user_show, :user_create, :finish, :user_edit, :user_update, :edit_student_response, :user_help, :deadline, :user_delete_student_url]
end
