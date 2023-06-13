class UserSignupController < ApplicationController
  include Wicked::Wizard
  layout 'devise'

  steps(*User.form_steps)

  def show
    @user = current_user
    case step 
    when 'sign_up'
      skip_step if @user.persisted?
    end
    render_wizard
  end

  def update
    @user = current_user
    case step 
    when 'personal'
      render_wizard @user, status: :unprocessable_entity, notice: 'Add a organization name' and return unless params[:user][:org_name].present?
      @org = Organization.new(name: params[:user][:org_name] )
      if @org.save
        @user.organization_id = @org.id
        @user.is_admin = true
        if @user.update(onboarding_params(step))
          render_wizard @user
        else
          render_wizard @user, status: :unprocessable_entity
        end
      else
        render_wizard @user, status: :unprocessable_entity
      end
      
    when 'apps'
      render_wizard @user, status: :unprocessable_entity, notice: 'Select Atleast 1 module' and return unless params[:user][:modules].present? and params[:user][:modules].reject{|e|e.to_s.empty?}.count > 0
      if @user.update(modules: params[:user][:modules].reject{|e|e.to_s.empty?})
        render_wizard @user
      else
        render_wizard @user, status: :unprocessable_entity
      end
    end
  end

  private

  def finish_wizard_path
    flash[:notice] = 'Profile completed successfully !'
    root_path
  end

  # def redirect_to_finish_wizard
  #   flash[:notice] = l(:mooc_registration_note_success)
  #   root_path
  # end

  def onboarding_params(step = 'sign_up')
    case step
    when 'personal'
      params.require(:user).permit(:id, :organization_name, :name, :phone_number, :org_name).merge(form_step: step)
    when 'apps'
      params.require(:user).permit(:id, :modules).merge(form_step: step)
    end
  end
  
end
