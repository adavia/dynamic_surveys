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
      render(association.to_s.singularize + "_fields", f: builder, parent: f.object)
    end
    link_to(name, "#", class: css, data: { id: id, fields: fields.gsub("\n", ""),
      behavior: "add_#{association.to_s.singularize}_fields" })
  end
end
