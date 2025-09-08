# Don't forget to add menu item in app/views/shared/admin/_sidebar.html.erb
class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.includes(:book).recent.page(params[:page]).per(20)
    
    # Search functionality
    if params[:search].present?
      @orders = @orders.joins(:book).where(
        "orders.customer_name ILIKE ? OR orders.customer_email ILIKE ? OR books.title ILIKE ?",
        "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%"
      )
    end
    
    # Filter by status
    if params[:status].present? && Order.statuses.key?(params[:status])
      @orders = @orders.where(status: params[:status])
    end
    
    # Filter by date range
    if params[:date_from].present?
      @orders = @orders.where('created_at >= ?', Date.parse(params[:date_from]))
    end
    
    if params[:date_to].present?
      @orders = @orders.where('created_at <= ?', Date.parse(params[:date_to]).end_of_day)
    end
    
    # Calculate totals
    @total_revenue = @orders.completed.sum(:total_amount)
    @total_orders = @orders.count
    @completed_orders = @orders.completed.count
  end

  def show
  end

  def update
    if params[:status].present? && Order.statuses.key?(params[:status])
      @order.update!(status: params[:status])
      
      # Mark as paid and reduce stock if changing to paid
      if params[:status] == 'paid' && @order.pending?
        @order.mark_as_paid!
        @order.book.decrement!(:stock) if @order.book.stock > 0
      end
      
      redirect_to admin_order_path(@order), notice: 'Order status updated successfully.'
    else
      redirect_to admin_order_path(@order), alert: 'Invalid status.'
    end
  end

  def destroy
    book_title = @order.book.title
    @order.destroy!
    redirect_to admin_orders_path, notice: "Order for '#{book_title}' was successfully deleted."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
