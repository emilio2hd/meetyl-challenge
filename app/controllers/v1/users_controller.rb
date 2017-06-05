module V1
  class UsersController < ApplicationController
    include V1::UsersModule

    before_action :set_user, only: [:show, :update]

    def index
      @users = User.all

      render json: @users, each_serializer: V1::UserSerializer
    end

    def show
      render json: @user, serializer: V1::UserSerializer
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: user, status: :created, serializer: V1::UserSerializer
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      if @user.update(user_params)
        render json: @user, serializer: V1::UserSerializer
      else
        render json: { errors: @user.errors }, status: :bad_request
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name)
    end
  end
end