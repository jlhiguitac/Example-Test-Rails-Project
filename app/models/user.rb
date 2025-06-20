class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true,
  format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
  message: :invalid }
  validates :username, presence: true, uniqueness: true,
  length: { minimum: 3, maximum: 20 },
  format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers, and underscores" }
  validates :password, presence: true, length: { minimum: 6 }
  has_many :products, dependent: :destroy
  before_save :downcase_attributes

  private
  def downcase_attributes
    self.email = email.downcase
    self.username = username.downcase
  end
end
