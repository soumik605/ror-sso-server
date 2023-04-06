class OauthClientsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @oauth_clients = current_user.user_oauth_clients
  end

end
