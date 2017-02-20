module ImagesHelper
  def displayed_image(image)
    if image.file.present?
      content_tag :div, nil, class: "img-preview",
        style: "background-image: url(#{image.file.url(:thumb)})"
    elsif image.reference_path.present?
      content_tag :div, nil, class: "img-preview",
        style: "background-image: url(#{image.reference_path})"
    else
      content_tag :div, nil, class: "img-preview",
        style: "background-image: url(#{asset_path('default_avatar.png')})"
    end
  end
end
