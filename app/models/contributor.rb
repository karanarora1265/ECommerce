class Contributor < User
	has_many :brands, through: 'BrandManager'
	has_many :brand_managers
	belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id'
end