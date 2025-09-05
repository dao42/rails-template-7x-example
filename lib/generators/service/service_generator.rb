class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  desc "Generate a service class"

  def create_service_file
    template 'service.rb.erb', "app/services/#{file_name}_service.rb"
  end

  private

  def file_name
    name.underscore
  end

  def class_name
    "#{name.classify}Service"
  end
end
