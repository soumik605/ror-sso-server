class AdminUser::UsersController < ApplicationController
  before_action :check_admin_user
  before_action :set_user, only: %i[ update destroy ]

  def index
    @users = User.all.order("created_at ASC")
    @users = @users.search_by_text(params[:search]) if params[:search].present?
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(user_params)
    @users = User.all.order("created_at ASC")
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_users_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, user: @user }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @users = User.all.order("created_at ASC")
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_user_users_path, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, user: @user }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_user_users_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :is_admin, :name, :organization_name, :phone_number)
  end

end
