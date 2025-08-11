# Prevent Rails from wrapping form fields with div.field_with_errors (which breaks your layout)
ActionView::Base.field_error_proc = Proc.new do |html_tag, _instance|
  html_tag.html_safe
end
