class AddAppUrlToOauthClient < ActiveRecord::Migration[7.0]
  def change
    add_column :oauth_clients, :app_url, :string
  end
end
