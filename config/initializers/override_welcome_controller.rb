# config/initializers/override_welcome_controller.rb
Rails.application.config.to_prepare do
  next unless defined?(Rails::WelcomeController)

  Rails::WelcomeController.class_eval do
    def index
      custom = Rails.root.join("app/views/shared/missing_welcome_index.html.erb")
      render file: custom, layout: false, content_type: 'text/html'
    end
  end
end
