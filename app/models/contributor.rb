class Contributor < User
	has_many :brand_managers, foreign_key: :user_id
	has_many :brands, through: :brand_managers
	belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id'
end