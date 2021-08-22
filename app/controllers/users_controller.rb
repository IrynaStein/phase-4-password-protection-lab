class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  before_action :authorize, only: [:show]

  def create
    user = User.create!(user_params)
    user.valid?
    session[:user_id] = user.id
    render json: user, status: :created
  end

  def show
    # byebug
    user = User.find_by(id: session[:user_id])
    render json: user
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def authorize
    return render json: {error: "Unauthorized access, please login"}, status: :unauthorized unless session.include?(:user_id)
  end

  def render_unprocessable_entity_response(invalid)
    # byebug
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
