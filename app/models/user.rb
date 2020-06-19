class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = Settings.email_regex
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation)

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: Settings.user.name.max_length }
  validates :email, presence: true, length: { maximum: Settings.user.emails.max_length },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: Settings.user.password.min_length }

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  class << self
    def digest string
      cost =  if ActiveModel::SecurePassword.min_cost
                BCrypt::Engine::MIN_COST
              else
                BCrypt::Engine.cost
              end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end

end
