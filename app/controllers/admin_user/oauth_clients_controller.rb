class AdminUser::OauthClientsController < ApplicationController
  before_action :set_oauth_client, only: %i[ update destroy ]

  def index
    @oauth_clients = OauthClient.all.order("created_at ASC")
    @oauth_client = OauthClient.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @oauth_client = OauthClient.new(oauth_client_params)
    respond_to do |format|
      if @oauth_client.save
        format.html { redirect_to admin_user_oauth_clients_url, notice: "Oauth client was successfully created." }
        format.json { render :show, status: :created, oauth_client: @oauth_client }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @oauth_client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @oauth_client.update(oauth_client_params)
        format.html { redirect_to admin_user_oauth_clients_path, notice: "Oauth client was successfully updated." }
        format.json { render :show, status: :ok, oauth_client: @oauth_client }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @oauth_client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @oauth_client.destroy
    respond_to do |format|
      format.html { redirect_to admin_user_oauth_clients_path, notice: "Oauth client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_oauth_client
    @oauth_client = OauthClient.find(params[:id])
  end

  def oauth_client_params
    params.require(:oauth_client).permit(:name, :app_id, :app_secret)
  end
end
