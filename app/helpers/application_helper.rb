module ApplicationHelper
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(Rails.root) + '/public' + image
    tag(:img, options)
  end

  def flash_class(level)
    case level
        when :notice then "alert alert-info"
        when :success then "alert alert-success"
        when :error then "alert alert-error"
        when :alert then "alert alert-error"
    end
  end
end
