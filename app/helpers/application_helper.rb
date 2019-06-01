module ApplicationHelper
  def pdf_image_tag(image, options = {})
    options[:src] = pdf_image_src(image)
    tag(:img, options)
  end

  def pdf_image_src(image)
    File.expand_path(Rails.root) + '/public' + image
  end

  def pdf_background
    File.expand_path(Rails.root) + '/public/images/bg.png'
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
