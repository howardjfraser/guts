module ApplicationHelper
  def full_title(page_title)
    page_title + ' | Guts'
  end

  def error_class(object, field)
    'has-danger' if error? object, field
  end

  def error_message(object, field)
    error object.errors.full_messages_for(field)[0] if error? object, field
  end

  def custom_error_message(object, field, label)
    error "#{label} #{object.errors.get(field)[0]}" if error? object, field
  end

  private

  def error?(object, field)
    object.errors[field].count > 0
  end

  def error(msg)
    content_tag(:span, msg, class: 'text-danger')
  end
end
