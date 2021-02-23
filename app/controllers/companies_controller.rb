class CompaniesController < ApplicationController

  respond_to :json
  def create
    if is_admin?
      @company = @current_user.companies.new(company_params)
      if @company.valid?
        @company.save
        render :json=> { success: true }, status: 201
      else
        render :json=> { success: false, message: "Company attrs are invalid"}, status: 400
      end
    else
      render :json=> { success: false, message: "Not allowed to create company"}, status: 403
    end
  end

  private
  def company_params
    params.require(:company).permit(:name)
  end  

end