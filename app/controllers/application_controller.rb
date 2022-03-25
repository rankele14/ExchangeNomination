class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  $max_limit = 3
end
