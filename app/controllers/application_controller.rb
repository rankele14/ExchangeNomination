class ApplicationController < ActionController::Base
  $max_limit = 5

  def update_max (new_max)
    $max_limit = new_max    
  end
end
