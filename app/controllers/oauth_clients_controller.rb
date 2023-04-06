class OauthClientsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @oauth_clients = OauthClient.all
  end

end
