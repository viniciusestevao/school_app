class User < ApplicationRecord
  # Devise modules disponíveis: 
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role,   { member: 0, admin: 1 }
  enum :status, { active: 0, inactive: 1 }

  validates :name, presence: true
end