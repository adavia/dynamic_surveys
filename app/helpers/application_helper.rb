module ApplicationHelper
  def title(*parts)
    unless parts.empty?
      content_for :title do
        (parts << "Dynamic Surveys").join(" - ")
      end
    end
  end

  def link_to_add_fields(name, f, association, css)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: css, data: { id: id, fields: fields.gsub("\n", ""),
      behavior: "add_#{association.to_s.singularize}_fields" })
  end

  def is_admin?
    current_user.try(:admin?)
  end

  def file_name(file)
    file.to_s.split("/").last
  end

  def display_image(image, default)
    if !image.blank?
      image_tag(image.url(:thumb), class: "img-responsive center-block img-thumbnail")
    else
      image_tag(default, class: "img-responsive center-block", size: "150x150")
    end
  end

  def is_active(controller)
    "active" if params[:controller] == controller
  end

  def get_percentage(value, total)
    percentage = (Float(value) / total * 100)
    if !percentage.nan?
      percentage.round(1)
    else
      0
    end
  end

  def total_percentage(arr)
    if arr.any?
      "#{arr.map { |a| get_percentage(a[1], arr.values.reduce(:+)) }.reduce(:+).round}"
    end
  end

  def get_avg(values)
    if values.any?
      array = values.map { |v| v.avg }
      number_with_precision(array.inject{ |sum, el| sum + el }.to_f / array.size, precision: 2)
    end
  end
end
