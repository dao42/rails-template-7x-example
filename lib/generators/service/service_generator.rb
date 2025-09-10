class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  desc "Generate a service class"

  def create_service_file
    template 'service.rb.erb', "app/services/#{file_name}.rb"
  end

  private

  def file_name
    if name.downcase.end_with?('service')
      base_name = name.gsub(/service$/i, '')
      standardized_base = standardize_class_name(base_name).underscore
      "#{standardized_base}_service"
    else
      standardized_name = standardize_class_name(name).underscore
      "#{standardized_name}_service"
    end
  end

  def class_name
    if name.downcase.end_with?('service')
      base_name = name.gsub(/service$/i, '')
      standardized_base = standardize_class_name(base_name)
      "#{standardized_base}Service"
    else
      standardized_name = standardize_class_name(name)
      "#{standardized_name}Service"
    end
  end

  def standardize_class_name(name)
    name.underscore.classify
  end
end
