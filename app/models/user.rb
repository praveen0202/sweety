class User < ApplicationRecord
  self.inheritance_column = 'user_type'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  before_create :set_default_role

  has_many :blood_glucose_levels

  private

  def set_default_role
    self.user_type = "Patient"
  end
end
