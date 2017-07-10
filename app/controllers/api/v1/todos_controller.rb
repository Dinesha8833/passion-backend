class Api::V1::TodosController < Api::V1::BaseController
  before_action :set_todo, only: [:update, :destroy]

  # GET /api/v1/todos
  def index
    render json: current_user.todos
  end

  # POST /api/v1/todos
  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      render json: @todo
    else
      render_error_with_message(@todo.errors.full_messages.join(', '), :bad_request)
    end
  end

  # PUT/PATCH /api/v1/todos/:id
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render_error_with_message(@todo.errors.full_messages.join(', '), :bad_request)
    end
  end

  # DELETE /api/v1/todos/:id
  def destroy
    if @todo.delete
      render json: @todo
    else
      render_error_with_message(@todo.errors.full_messages.join(', '), :bad_request)
    end
  end

  private
  def set_todo
    @todo = current_user.todos.where(id: params[:id]).first
    unless @todo
      render_error_with_message("Either todo does not exist or you dont have access to it", :not_found)
    end
  end

  def todo_params
    params.required(:todo).permit(:name)
  end
end
