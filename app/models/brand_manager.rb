class BrandManager < ApplicationRecord
  belongs_to :user
  belongs_to :brand
  belongs_to :creator, class_name: 'Admin', foreign_key: 'admin_id'

  def is_valid?
	user_valid? and brand_valid?
  end

  def user_valid?
  	creator.contributors.pluck(:id).include? user_id
  end

  def brand_valid?
  	creator.my_created_brands.pluck(:id).include? brand_id
  end
end
