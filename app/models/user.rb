class User < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validate :password_complexity, if: :password_required?

  has_secure_password


  def authenticate(password)
    super(password) 
  end

  def admin?
    self.role == 'admin'
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex(10)
    save
    self.auth_token
  end

  def reset_password(new_password)
    self.password = new_password
    save
  end

  private

  def password_complexity
    return if password.blank?

    unless password.match(/^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/)
      errors.add :password, 'deve conter pelo menos uma letra e um dígito, e ter no mínimo 8 caracteres'
    end
  end

  def password_required?
    password_digest.nil? || !password.nil?
  end
end
