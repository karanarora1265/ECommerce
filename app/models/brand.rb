class Brand < ApplicationRecord
  belongs_to :company
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :managers, class_name: 'User', through: 'BrandManager'
  has_many :brand_managers

  validates :name, presence: true

end
