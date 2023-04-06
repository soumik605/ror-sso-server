class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def check_admin_user
    unless current_user.admin_user?
      redirect_to root_path
    end
  end

end
