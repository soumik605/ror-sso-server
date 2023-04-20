class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :check_if_profile_complete 

  def check_admin_user
    unless current_user.admin_user?
      redirect_to root_path
    end
  end

  private

  def check_if_profile_complete
    return unless current_user.present?
    return if controller_name == 'user_signup'
    if current_user.try(:name).nil? or current_user.try(:phone_number).nil? or current_user.try(:organization_name).nil? 
      redirect_to user_signup_path('personal'), notice: "Please complete your profile."
    elsif current_user.try(:modules).nil? or current_user.try(:modules).try(:count) == 0
      redirect_to user_signup_path('apps'), notice: "Please complete your profile."
    end
  end

end
