class User < ApplicationRecord
  VALID_MAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save :mail_downcase
  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :mail, presence: true, length: {maximum: Settings.max_mail},
    format: {with: VALID_MAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.min_pass}
  has_secure_password

  private
  def mail_downcase
    mail.downcase!
  end
end
