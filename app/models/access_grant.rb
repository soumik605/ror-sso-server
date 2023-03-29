class AccessGrant < ApplicationRecord
  belongs_to :user
  belongs_to :client

  before_create :generate_tokens

  # Generate random tokens
  def generate_tokens
    self.code = SecureRandom.hex(16)
    self.access_token = SecureRandom.hex(16)
    self.refresh_token = SecureRandom.hex(16)
  end
end
