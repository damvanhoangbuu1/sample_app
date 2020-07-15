class User < ApplicationRecord
  attr_accessor :remember_token
  before_save{email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.NAME_MAXIMUM}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: {maximum: Settings.EMAIL_MAXIMUM},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.PASSWORD_MINIMUM}

  def self.digest string
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost = BCrypt::Engine.cost unless ActiveModel::SecurePassword.min_cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update(remember_digest: nil)
  end
end
