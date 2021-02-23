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

  def index
    if is_contributor?
      @brands = @current_user.brands
      render :json=> { brands: @brands.to_json }, status: 200
    else
      render :json=> { success: false, message: "Not allowed to access brand"}, status: 403
    end
  end

  private
  def brand_params
    params.require(:brand).permit(:name, :company_id)
  end  

end