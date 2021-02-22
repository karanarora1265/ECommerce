class RegistrationsController < Devise::RegistrationsController
  def create
    user = User.new(user_params)
    if user.valid?
      if @current_user.is_a? SuperAdmin
        user.type = 'Admin'
      elsif @current_user.is_a? Admin
        user.type = 'Contributor'
      end
      if user.save
        send_email
        render :json=> { :success=>true, :email=>user.email }, :status=>201
      end
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :bio, :image)
  end  

  def send_email
    
  end

end