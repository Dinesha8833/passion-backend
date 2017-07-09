class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo
  before_action :set_item, only: [:update, :complete, :destroy]

  # GET /api/v1/todos/:todo_id/items
  def index
    render json: @todo.items.sort_by_index
  end

  # POST /api/v1/todos/:todo_id/items
  def create
    @item = @todo.items.build(item_params)
    if @item.save
      render json: @item
    else
      render json: {
        success: false,
        message: @item.errors.full_messages.join(', ')
      }
    end
  end

  # PUT/PATCH /api/v1/todos/:todo_id/items/:id
  def update
    if @item.update_attributes(item_params)
      render json: @item
    else
      render json: {
        success: false,
        message: @item.errors.full_messages.join(', ')
      }
    end
  end

  # PATCH /api/v1/todos/:todo_id/items/:id/complete
  def complete
    if @item.complete!
      render json: @item
    else
      render json: {
        success: false,
        message: @item.errors.full_messages.join(', ')
      }
    end
  end

  # DELETE /api/v1/todos/:todo_id/items/:id
  def destroy
    if @item.delete
      render json: @item
    else
      render json: {
        success: false,
        message: @item.errors.full_messages.join(', ')
      }
    end
  end

  private
  def set_todo
    @todo = current_user.todos.where(id: params[:todo_id]).first
    unless @todo
      render json: {
        success: false,
        message: "Either todo does not exist or you dont have access to it"
      }
    end
  end

  def set_item
    @item = @todo.items.where(id: params[:id]).first
    unless @item
      render json: {
        success: false,
        message: "Either item does not exist or you dont have access to it"
      }
    end
  end

  def item_params
    params.required(:item).permit(:title, :sort_index)
  end
end
