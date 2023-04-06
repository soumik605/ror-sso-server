class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants, dependent: :delete_all

  validates_presence_of :name, :email, :phone_number
  validates_uniqueness_of :email, :phone_number

  def oauth_payload
    _hash = {
      provider: 'sso',
      id: self.id,
      info: {
         email: self.email,
         name: self.email, # TODO for you: Handle name and pass the data here
      },
      extra: {
        first_name: "TODO", # TODO for you: To pass the relevant data here
        last_name: "TODO", # TODO for you: To pass the relevant data here
        mobile_number: "123456789", # TODO for you: To pass the relevant data here
      }
    }
    return _hash
  end

  def admin_user?
    self.try(:is_admin)
  end

  def user_oauth_clients
    OauthClient.joins(:access_grants).where("access_grants.user_id = ?", self.id).uniq
  end

  def self.search_by_text(query)
    where(<<-SQL, "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%")
      users.email ilike ?
      users.phone_number ilike ?
      users.name ilike ?
    SQL
  end

end
