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

  def flash_class(level)
    case level
    when 'notice', 'success' then 'alert alert-success alert-dismissible'
    when 'info' then 'alert alert-info alert-dismissible'
    when 'warning' then 'alert alert-warning alert-dismissible'
    when 'alert', 'error' then 'alert alert-danger alert-dismissible'
    end
  end

  # TailAdmin flash message class helper
  def flash_tailwind_class(level)
    case level.to_sym
    when :notice, :success
      'border-success-300 bg-success-50 dark:border-success-300 dark:bg-success-900 text-success-500'
    when :info
      'border-info-300 bg-info-50 dark:border-info-300 dark:bg-info-900 text-info-500'
    when :warning
      'border-warning-300 bg-warning-50 dark:border-warning-300 dark:bg-warning-900 text-warning-500'
    when :alert, :error
      'border-danger-300 bg-danger-50 dark:border-danger-300 dark:bg-danger-900 text-danger-500'
    else
      'border-primary-300 bg-primary-50 dark:border-primary-300 dark:bg-primary-900 text-primary-500'
    end
  end

  # Flash message title helper
  def flash_title(level)
    case level.to_sym
    when :notice, :success
      'Success!'
    when :info
      'Information'
    when :warning
      'Warning!'
    when :alert, :error
      'Error!'
    else
      'Notification'
    end
  end
end
