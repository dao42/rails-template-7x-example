class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def create
    @book = Book.find(params[:book_id])
    
    unless @book.available?
      redirect_to @book, alert: 'This book is currently out of stock.'
      return
    end

    # Create order
    @order = Order.new(
      book: @book,
      customer_email: params[:customer_email],
      customer_name: params[:customer_name],
      total_amount: @book.price,
      status: 'pending'
    )

    if @order.save
      # Create Stripe Checkout Session
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'usd',
            product_data: {
              name: @book.title,
              description: "by #{@book.author}",
              images: [@book.cover_image_url]
            },
            unit_amount: @book.price_in_cents,
          },
          quantity: 1,
        }],
        mode: 'payment',
        success_url: "#{request.base_url}/payments/success?order_id=#{@order.id}",
        cancel_url: "#{request.base_url}/payments/cancel?order_id=#{@order.id}",
        customer_email: @order.customer_email,
        metadata: {
          order_id: @order.id
        }
      })

      @order.update!(stripe_payment_intent_id: session.id)
      redirect_to session.url, allow_other_host: true
    else
      redirect_to @book, alert: 'There was an error processing your order.'
    end
  rescue Stripe::StripeError => e
    redirect_to @book, alert: "Payment error: #{e.message}"
  end

  def success
    @order = Order.find(params[:order_id]) if params[:order_id]
    if @order&.pending?
      @order.mark_as_paid!
      # Decrease book stock
      @order.book.decrement!(:stock)
    end
  end

  def cancel
    @order = Order.find(params[:order_id]) if params[:order_id]
    @order&.update(status: 'cancelled')
  end

  # Stripe webhook endpoint
  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    case event['type']
    when 'checkout.session.completed'
      session = event['data']['object']
      order_id = session['metadata']['order_id']
      order = Order.find_by(id: order_id)
      
      if order&.pending?
        order.mark_as_paid!
        order.book.decrement!(:stock)
      end
    end

    render json: { status: 'success' }
  end
end
