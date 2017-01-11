module QuestionsHelper
  def show_choice_button(question_type)
    if ["open", "date", "image", "rating"].include?(question_type) || question_type.nil?
      "hidden"
    end
  end

  def show_option_button(question_type)
    if question_type != "list" || question_type.nil?
      "hidden"
    end
  end

  def show_image_button(question_type)
    if question_type != "image" || question_type.nil?
      "hidden"
    end
  end
end
