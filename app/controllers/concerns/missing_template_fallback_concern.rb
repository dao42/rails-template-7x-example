module MissingTemplateFallbackConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::MissingExactTemplate, with: :render_missing_template_fallback
  end

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
