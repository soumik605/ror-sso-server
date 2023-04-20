class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants, dependent: :delete_all

  enum :apps, { proteger_crm: 1, proteger_cmms: 2, proteger_analytics: 3  }

  validates_presence_of :email
  validates_uniqueness_of :email

  cattr_accessor :form_steps do
    %w[sign_up personal apps]
  end

  attr_accessor :form_step

  with_options if: -> { required_for_step?('personal') } do |step|
    step.validates :organization_name, presence: true
    step.validates :name, presence: true
    step.validates :phone_number, presence: true, uniqueness: true
  end

  with_options if: -> { required_for_step?('apps') } do |step|
    step.validates :modules, presence: true
  end


  def form_step
    @form_step ||= "sign_up"
  end

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
      OR users.phone_number ilike ?
      OR users.name ilike ?
    SQL
  end

  def required_for_step?(step)
    return true if form_step.nil?
    return true if form_steps.index(step.to_s) <= form_steps.index(form_step.to_s)
  end

end
