class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user, only: [:create]
  respond_to :json
  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      @current_user = user
      render :json=> { :token=>user.generate_jwt, :email=>user.email }, :status=>200
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

end