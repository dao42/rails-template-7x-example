module FriendlyErrorHandlingConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActionView::SyntaxErrorInTemplate, with: :handle_friendly_error
    rescue_from ActiveRecord::StatementInvalid, with: :handle_friendly_error
    rescue_from StandardError, with: :handle_friendly_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_friendly_error
  end

  private

  def handle_friendly_error(exception)
    Rails.logger.error("Application Error: #{exception.class.name}")
    Rails.logger.error("Message: #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))

    if request.format.html?
      @error_url = request.path
      @original_exception = exception if Rails.env.development?
      render "shared/friendly_error", status: :internal_server_error
    else
      render json: {
        error: 'An error occurred',
        message: Rails.env.development? ? exception.message : 'Please try again later'
      }, status: :internal_server_error
    end
  end
end
