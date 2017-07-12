class Api::V1::ItemsController < Api::V1::BaseController
  before_action :set_todo
  before_action :set_item, only: [:update, :complete, :set_order, :destroy]

  # GET /api/v1/todos/:todo_id/items
  def index
    render json: @todo.items.sort_by_index.paginate(:page => params[:page])
  end

  # POST /api/v1/todos/:todo_id/items
  def create
    @item = @todo.items.build(item_params)
    if @item.save
      render json: @item
    else
      render_error_with_message(@item.errors.full_messages.join(', '), :bad_request)
    end
  end

  # PUT/PATCH /api/v1/todos/:todo_id/items/:id
  def update
    if @item.update_attributes(item_params)
      render json: @item
    else
      render_error_with_message(@item.errors.full_messages.join(', '), :bad_request)
    end
  end

  # PATCH /api/v1/todos/:todo_id/items/:id/complete
  def complete
    render_error_with_message("Item is already completed", :bad_request) and return if @item.completed?
    if @item.complete!
      render json: @item
    else
      render_error_with_message(@item.errors.full_messages.join(', '), :bad_request)
    end
  end

  # PATCH /api/v1/todos/:todo_id/items/:id/set_order
  def set_order
    if @item.set_order(params[:item][:sort_index])
      render json: @item
    else
      render_error_with_message(@item.errors.full_messages.join(', '), :bad_request)
    end
  end

  # DELETE /api/v1/todos/:todo_id/items/:id
  def destroy
    if @item.delete
      render json: @item
    else
      render_error_with_message(@item.errors.full_messages.join(', '), :bad_request)
    end
  end

  private
  def set_todo
    @todo = Todo.where(id: params[:todo_id]).first
    unless @todo
      render_error_with_message("Either todo does not exist or you dont have access to it", :not_found)
    end
  end

  def set_item
    @item = @todo.items.where(id: params[:id]).first
    unless @item
      render_error_with_message("Either item does not exist or you dont have access to it", :not_found)
    end
  end

  def item_params
    params.required(:item).permit(:title, :sort_index)
  end
end
