class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { in: 3..255 }

  validates :username, presence: true, length: { in: 5..50 },
    format: { with: /\A[a-zA-Z0-9\-_]+\z/, message: "apenas letras, números, - e _" }, uniqueness: true

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, presence: true, length: { in: 20..100 }, confirmation: true, on: :create
end
