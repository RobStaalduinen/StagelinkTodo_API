class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]
  wrap_parameters :todo, include: [:task, :description, :priority, :category_id, :user_id]

  # GET /todos
  def index
    @todos = Todo.all

    render json: @todos
  end

  # GET /todos/1
  def show
    render json: @todo
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
  end

  def find_by_category
    category = Category.includes(:todos).find(params[:id])
    @todos = category.todos

    render json: @todos
  end

  def find_by_user
    user = User.includes(:todos).find(params[:id])
    @todos = user.todos

    render json: @todos
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Todo not found" }, status: :not_found
    end

    # Only allow a trusted parameter "white list" through.
    def todo_params
      params.require(:todo).permit(:task, :description, :category_id, :priority, :user_id)
    end
end
