class User < ActiveRecord::Base
  ROLES = %w(root admin user)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me, :role
  validates_format_of :username, :with => /^[0-9a-zA-Z\p{Han}]{3,15}$/
  validates :username, :uniqueness => { :case_sensitive => false }
  validates :role, :inclusion => { :in => ROLES }
  # attr_accessible :title, :body
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def as_option
    "[%s] #{username}" % I18n::t("helpers.label.user.role_#{role}")
  end
end

class String
  def real_role_name
    I18n::t("helpers.label.user.role_%s" % self)
  end
end
