class CategoriesController < ApplicationController
	before_action :set_category, only: [:show, :update, :destory]

	def index
		@categories = Category.all

		render json: @categories
	end

	def show
		render json: @category
	end

	def create
		@category = Category.new(category_params)
		if @category.save
      		render json: @category, status: :created, location: @category
   	 	else
      		render json: @category.errors, status: :unprocessable_entity
    	end
	end

	def update
		@category.update(category_params)

		if @category.save
			render json: @category
		else
			render json: @category.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@category.destory
	end

	private
		def set_category
			@category = Category.find(params[:id])
		end

		def category_params
			params.require(:category).permit(:name)
		end

end
