class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :destroy]

  def index
    @orders = Order.search(params[:search])
                  .page(params[:page])
                  .per(20)

    # Filter by status if provided
    @orders = @orders.where(status: params[:status]) if params[:status].present?

    # Filter by date range if provided
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      if start_date && end_date
        @orders = @orders.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
      end
    end

    # Statistics for dashboard
    @stats = {
      total_orders: Order.count,
      pending_orders: Order.pending.count,
      processing_orders: Order.processing.count,
      paid_orders: Order.paid.count,
      failed_orders: Order.failed.count,
      total_revenue: Order.paid.sum(:amount),
      today_orders: Order.where(created_at: Date.current.all_day).count,
      today_revenue: Order.paid.where(created_at: Date.current.all_day).sum(:amount)
    }
  end

  def show
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: 'Order was successfully deleted.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
