class BrandManagersController < ApplicationController

  respond_to :json
  def create
    if is_admin?
      @brand_manager = @current_user.my_assigned_brands.new(brand_manager_params)
      if @brand_manager.is_valid?
        @brand_manager.save
        render :json=> { success: true }, status: 201
      else
        render :json=> { success: false, message: "Attrs are invalid"}, status: 400
      end
    else
      render :json=> { success: false, message: "Not allowed to create brand"}, status: 403
    end
  end

  private
  def brand_manager_params
    params.require(:brand_manager).permit(:user_id, :brand_id)
  end  

end