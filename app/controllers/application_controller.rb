class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from ActionController::MissingExactTemplate, with: :render_missing_template_fallback

  private

  def render_missing_template_fallback(exception)
    if request.format.html?
      Rails.logger.info("Missing template: #{exception}. Fallback rendering.")
      render "shared/missing_template_fallback", status: :ok
    else
      raise exception
    end
  end

end
