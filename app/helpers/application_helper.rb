module ApplicationHelper
  
  def checkbox_type params, type, content
    params && params[type] && params[type].include?(content)
  end
end
