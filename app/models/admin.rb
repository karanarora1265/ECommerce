class Admin < User
	has_many :companies, foreign_key: :user_id
end