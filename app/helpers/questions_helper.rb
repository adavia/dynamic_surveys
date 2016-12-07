module QuestionsHelper
  def show_choice_button(question_type)
    if [1, 4, 6].include?(question_type) || question_type.nil?
      "hidden"
    end
  end

  def show_option_button(question_type)
    if question_type != 7 || question_type.nil?
      "hidden"
    end
  end

  def show_image_button(question_type)
    if question_type != 5 || question_type.nil?
      "hidden"
    end
  end
end
