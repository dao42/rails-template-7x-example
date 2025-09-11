module ApplicationHelper
  # Generate `{controller}-{action}-page` class for body element
  def body_class
    path = controller_path.tr('/_', '-')
    action_name_map = {
      index: 'index',
      new: 'edit',
      edit: 'edit',
      update: 'edit',
      patch: 'edit',
      create: 'edit',
      destory: 'index'
    }
    mapped_action_name = action_name_map[action_name.to_sym] || action_name
    body_class_page = format('%s-%s-page', path, mapped_action_name)
    body_class_page
  end

  # Admin active for helper
  def admin_active_for(controller_name, navbar_name)
    if controller_name.to_s == admin_root_path
      return controller_name.to_s == navbar_name.to_s ? "active" : ""
    end
    navbar_name.to_s.include?(controller_name.to_s) ? 'active' : ''
  end

  def current_path
    request.env['PATH_INFO']
  end


  # DaisyUI flash message class helper
  def flash_daisy_class(level)
    case level.to_sym
    when :notice, :success
      'alert-success'
    when :info
      'alert-info'
    when :warning
      'alert-warning'
    when :alert, :error
      'alert-error'
    else
      'alert-info'
    end
  end

  # Dynamic validation helpers for admin forms
  def field_required?(model, field_name)
    model.class.validators_on(field_name.to_sym).any? { |v| v.is_a?(ActiveModel::Validations::PresenceValidator) }
  end
end
