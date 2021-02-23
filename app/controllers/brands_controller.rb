class BrandsController < ApplicationController

  respond_to :json
  def create
    if is_admin?
      @brand = @current_user.my_created_brands.new(brand_params)
      if @brand.valid?
        @brand.save
        render :json=> { success: true }, status: 201
      else
        render :json=> { success: false, message: "Brand attrs are invalid"}, status: 400
      end
    else
      render :json=> { success: false, message: "Not allowed to create brand"}, status: 403
    end
  end

  private
  def brand_params
    params.require(:brand).permit(:name, :company_id)
  end  

end