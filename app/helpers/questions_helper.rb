module QuestionsHelper
  def show_btn_choice(type)
    if !["single", "list", "multiple"].include?(type)
      "hidden"
    end
  end

  def show_btn_image(type)
    if type != "image"
      "hidden"
    end
  end

  def show_btn_rating(type)
    if type != "rating"
      "hidden"
    end
  end
end
