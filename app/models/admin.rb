class Admin < User
	has_many :companies, foreign_key: :user_id
	has_many :my_created_brands, class_name: 'Brand', foreign_key: 'user_id'
	has_many :my_assigned_brands, class_name: 'BrandManager', foreign_key: 'admin_id'
	has_many :contributors, class_name: 'User', foreign_key: 'created_by_id'
end