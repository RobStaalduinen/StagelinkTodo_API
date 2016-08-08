class UsersController < ApplicationController

	before_action :set_user, only: [:show, :update, :destroy, :login]
	#Wrap parameters so JSON params can be submitted as a simple hash
	wrap_parameters :user, include: [:username, :email, :password, :password_confirmation]

	def create
		@user = User.new(user_params)
		if @user.save
			render json: @user
		else
			render json: { errors: @user.errors }, status: 422
		end
	end

	def show
		render json: @user
	end

	def update
		if @user.update(user_params)
	      render json: @user
	    else
	      render json: @user.errors, status: :unprocessable_entity
	    end
	end

	def destroy
		#Cleanup users ToDo entries
		todos = @user.todos
		todos.destroy_all

		@user.destroy
	end

	def login
		@authenticated_user = @user.authenticate(params[:password])

		render json: {login_status: @authenticated_user}
	end

	private

		def set_user
			@user = User.find(params[:id])
			rescue ActiveRecord::RecordNotFound
        		render json: { error: "User not found" }, status: :not_found
		end

		def user_params
			params.require(:user).permit(:username, :email, :password, :password_confirmation)
		end
end
