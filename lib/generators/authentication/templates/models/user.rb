class User < ApplicationRecord
  MIN_PASSWORD = 4

  has_secure_password validations: false

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end
  generates_token_for :password_reset, expires_in: 20.minutes

  has_many :sessions, dependent: :destroy

  validates :name, presence: true, length: { minimum: 4 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: MIN_PASSWORD }, if: :password_required?

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  # OAuth methods
  def self.from_omniauth(auth)
    find_or_create_by(email: auth.info.email) do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.verified = true
    end
  end

  def oauth_user?
    provider.present? && uid.present?
  end

  private

  def password_required?
    return false if oauth_user?
    password_digest.blank? || password.present?
  end

end
