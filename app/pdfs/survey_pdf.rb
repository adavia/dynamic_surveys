class SurveyPdf < Prawn::Document
  def initialize(survey, view)
    super()
    @survey = survey
    @view = view
    logo
    header
    statistics
    questions
  end

  def logo
    #This inserts an image in the pdf file and sets the size of the image
    image "#{Rails.root}/app/assets/images/logo.png", width: 200, position: :center
  end

  def header
    text_box "Survey created on #{@survey.created_at.strftime('%m/%d/%Y at %I:%M%p')}",
    at: [160, cursor - 5]
    # The cursor for inserting content starts on the top left of the page.
    # Here we move it down a little to create more space between the text
    # and the image inserted above

    move_down 40

    text "#{@survey.name}", size: 30, style: :bold
    text "#{@survey.description}", size: 15, style: :bold

  end

  def statistics
    move_down 15
    text_box "Questions #{@survey.questions_count}", size: 15, width: 120, :at => [0,  cursor - 2]
    text_box "Submissions #{@survey.submissions.size}", size: 15, width: 120, :at => [4 * 30,  cursor - 2]
  end

  def average_rating(rate)
    @view.number_with_precision(rate, precision: 2)
  end

  def questions
    move_down 40
    text "Survey questions", size: 25, style: :bold
    @survey.questions.each do |question|
      move_down 10
      text "#{question.title}", size: 20, style: :bold
      text "Answers #{question.answers.size}", size: 15
      if ["single", "select"].include? question.question_type.prefix
        question.answers.choice_counter.each do |answer|
          move_down 5
          text_box "#{answer[0]}", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "#{answer[1]}", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
          move_down 10
        end
      end
      if question.question_type.prefix == "image"
        question.answers.image_counter.each do |answer|
          move_down 5
          text_box "#{answer[0]}", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "#{answer[1]}", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
          move_down 10
        end
      end
      if question.question_type.prefix == "multiple"
        question.answers.multiple_choice_counter.each do |answer|
          move_down 5
          text_box "#{answer[0]}", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "#{answer[1]}", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
          move_down 10
        end
      end
      if question.question_type.prefix == "raiting"
        move_down 5
        if question.answers.any?
          text_box "Average rating", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "#{average_rating(question.answers.rating_average)}", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
        else
          text_box "Average rating", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "0", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
        end
        move_down 10
      end
    end
  end
end
