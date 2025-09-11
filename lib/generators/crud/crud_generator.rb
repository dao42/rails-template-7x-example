class CrudGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  # Simple data structure to replace OpenStruct
  ModelAttribute = Struct.new(:name, :type, :sql_type, :null, :default, keyword_init: true)

  argument :actions, type: :array, default: [], banner: "action action"

  def check_model_exists
    unless model_class_exists?
      say "Error: Model '#{class_name}' does not exist.", :red
      say "Please create the model first using: rails generate model #{class_name} [field:type ...]", :yellow
      exit(1)
    end
  end

  def generate_controller
    template "controller.rb.erb", "app/controllers/#{plural_name}_controller.rb"
  end

  def generate_views
    selected_actions.each do |action|
      case action
      when 'index'
        template "views/index.html.erb", "app/views/#{plural_name}/index.html.erb"
      when 'show'
        template "views/show.html.erb", "app/views/#{plural_name}/show.html.erb"
      when 'new'
        template "views/new.html.erb", "app/views/#{plural_name}/new.html.erb"
      when 'edit'
        template "views/edit.html.erb", "app/views/#{plural_name}/edit.html.erb"
      end
    end
  end

  def add_routes
    route "resources :#{plural_name}#{route_options}"
  end

  private

  def model_class_exists?
    begin
      class_name.constantize
      true
    rescue NameError
      false
    end
  end

  def model_class
    @model_class ||= class_name.constantize
  end

  def singular_name
    name.underscore.singularize
  end

  def plural_name
    name.underscore.pluralize
  end

  def class_name
    name.classify
  end

  def humanized_name
    singular_name.humanize
  end

  def humanized_plural_name
    plural_name.humanize
  end

  def model_columns
    @model_columns ||= model_class.columns.reject do |column|
      %w[id created_at updated_at].include?(column.name)
    end
  end

  def model_attributes
    @model_attributes ||= model_columns.map do |column|
      ModelAttribute.new(
        name: column.name,
        type: column.type,
        sql_type: column.sql_type,
        null: column.null,
        default: column.default
      )
    end
  end

  def permit_params
    model_attributes.map(&:name).map { |name| ":#{name}" }.join(', ')
  end

  def display_attributes
    # Return first few attributes for table display, prioritizing string/text fields
    attrs = model_attributes.select { |attr| %w[string text].include?(attr.type.to_s) }
    attrs = model_attributes if attrs.empty?
    attrs.first(3) # Limit to first 3 for table display
  end

  def form_field_for(attribute)
    case attribute.type.to_s
    when 'text'
      "text_area"
    when 'boolean'
      "check_box"
    when 'integer', 'decimal', 'float'
      "number_field"
    when 'date'
      "date_field"
    when 'datetime', 'timestamp'
      "datetime_local_field"
    when 'time'
      "time_field"
    else
      "text_field"
    end
  end

  def input_class_for(attribute)
    case attribute.type.to_s
    when 'text'
      "textarea"
    when 'boolean'
      "checkbox"
    else
      "input"
    end
  end

  def display_value_for(attribute, instance_var)
    case attribute.type.to_s
    when 'text'
      "simple_format(#{instance_var}.#{attribute.name})"
    when 'boolean'
      "#{instance_var}.#{attribute.name} ? 'Yes' : 'No'"
    when 'date', 'datetime', 'timestamp'
      "#{instance_var}.#{attribute.name}&.strftime('%Y-%m-%d %H:%M')"
    else
      "#{instance_var}.#{attribute.name}"
    end
  end

  def truncate_value_for(attribute, instance_var)
    case attribute.type.to_s
    when 'text'
      "truncate(#{instance_var}.#{attribute.name}, length: 100)"
    else
      "#{instance_var}.#{attribute.name}"
    end
  end

  def attribute_required?(attribute)
    # Check model validations for presence requirement
    model_class.validators_on(attribute.name.to_sym).any? do |validator|
      validator.is_a?(ActiveModel::Validations::PresenceValidator)
    end
  end

  def get_validation_info(attribute)
    # Get validation information for better form generation
    validators = model_class.validators_on(attribute.name.to_sym)
    info = {
      required: false,
      length_max: nil,
      length_min: nil,
      format: nil
    }
    
    validators.each do |validator|
      case validator
      when ActiveModel::Validations::PresenceValidator
        info[:required] = true
      when ActiveModel::Validations::LengthValidator
        info[:length_max] = validator.options[:maximum] if validator.options[:maximum]
        info[:length_min] = validator.options[:minimum] if validator.options[:minimum]
      when ActiveModel::Validations::FormatValidator
        info[:format] = validator.options[:with] if validator.options[:with]
      end
    end
    
    info
  end

  def selected_actions
    if actions.empty?
      %w[index show new edit]
    else
      actions
    end
  end

  def controller_actions
    actions_code = []
    
    if selected_actions.include?('index')
      actions_code << index_action
    end

    if selected_actions.include?('show')
      actions_code << show_action
    end

    if selected_actions.include?('new')
      actions_code << new_action
      actions_code << create_action
    end

    if selected_actions.include?('edit')
      actions_code << edit_action
      actions_code << update_action
    end

    if selected_actions.any? { |action| %w[new edit].include?(action) }
      actions_code << destroy_action
    end

    actions_code.join("\n\n")
  end

  def before_actions
    actions_needing_set = selected_actions.select { |action| %w[show edit].include?(action) }
    if selected_actions.include?('new')
      actions_needing_set += %w[update destroy]
    end
    if selected_actions.include?('edit')
      actions_needing_set += %w[update destroy]
    end
    
    actions_needing_set.uniq!
    
    if actions_needing_set.any?
      "before_action :set_#{singular_name}, only: [:#{actions_needing_set.join(', :')}]"
    else
      ""
    end
  end

  def route_options
    if actions.empty?
      ""
    else
      ", only: [:#{selected_actions.join(', :')}#{', :create' if selected_actions.include?('new')}#{', :update' if selected_actions.include?('edit')}#{', :destroy' if selected_actions.any? { |a| %w[new edit].include?(a) }}]"
    end
  end

  def index_action
    <<~ACTION
  def index
    @#{plural_name} = #{class_name}.page(params[:page]).per(10)
  end
    ACTION
  end

  def show_action
    <<~ACTION
  def show
  end
    ACTION
  end

  def new_action
    <<~ACTION
  def new
    @#{singular_name} = #{class_name}.new
  end
    ACTION
  end

  def create_action
    <<~ACTION
  def create
    @#{singular_name} = #{class_name}.new(#{singular_name}_params)

    if @#{singular_name}.save
      redirect_to #{singular_name}_path(@#{singular_name}), notice: '#{humanized_name} was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
    ACTION
  end

  def edit_action
    <<~ACTION
  def edit
  end
    ACTION
  end

  def update_action
    <<~ACTION
  def update
    if @#{singular_name}.update(#{singular_name}_params)
      redirect_to #{singular_name}_path(@#{singular_name}), notice: '#{humanized_name} was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
    ACTION
  end

  def destroy_action
    <<~ACTION
  def destroy
    @#{singular_name}.destroy
    redirect_to #{plural_name}_path, notice: '#{humanized_name} was successfully deleted.'
  end
    ACTION
  end
end
