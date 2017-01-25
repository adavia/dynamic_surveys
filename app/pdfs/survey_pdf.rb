require 'squid'

class SurveyPdf < Prawn::Document
  def initialize(survey, view)
    super()
    font "#{Rails.root}/app/assets/fonts/roboto-condensed.ttf"

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

  def date
    "#{I18n.l(@survey.created_at, format: :long)}"
  end

  def header
    text_box date, at: [210, cursor - 5]
    # The cursor for inserting content starts on the top left of the page.
    # Here we move it down a little to create more space between the text
    # and the image inserted above

    move_down 30

    text "#{@survey.name}", size: 30
    text "#{@survey.description}", size: 15

  end

  def statistics
    move_down 15
    table [[Question.human_attribute_name(:class_name).pluralize, "#{@survey.questions_count}"],
      [@view.t("app.survey.show.survey_submissions").capitalize, "#{@survey.submissions.size}"]] do
      self.header = true
      self.row_colors = ['DDDDDD', 'DDDDDD']
      self.column_widths = [150, 300]
    end
  end

  def average_rating(rate)
    @view.number_with_precision(rate, precision: 2)
  end

  def questions
    move_down 20
    text @view.t("app.survey.show.links.survey_questions"), size: 25
    @survey.questions.each do |question|
      move_down 10
      text "#{question.title}", size: 20
      move_down 5
      text "#{@view.t("app.survey.show.answers")}: #{question.answers.size}", size: 15
      if ["single", "list"].include? question.question_type
        if question.answers.choice_counter.any?
          if (y - cursor) + 250 > y
            start_new_page
            chart choices: question.answers.choice_counter
          else
            chart choices: question.answers.choice_counter
          end
        end
      end
      if question.question_type == "image"
        if question.answers.image_counter.any?
          if (y - cursor) + 250 > y
            start_new_page
            chart images: question.answers.image_counter
          else
            chart images: question.answers.image_counter
          end
        end
      end
      if question.question_type == "multiple"
        if question.answers.multiple_choice_counter.any?
          if (y - cursor) + 250 > y
            start_new_page
            chart choices: question.answers.multiple_choice_counter
          else
            chart choices: question.answers.multiple_choice_counter
          end
        end
      end
      if question.question_type == "rating"
        move_down 5
        if question.answers.any?
          text_box "#{@view.t("app.survey.show.average_rating")}:", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "#{average_rating(question.answers.rating_average)}", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
        else
          text_box "#{@view.t("app.survey.show.average_rating")}:", size: 12, width: 120, :at => [0,  cursor - 2]
          text_box "0", size: 12, width: 120, :at => [4 * 30,  cursor - 2]
        end
        move_down 15
      end
    end
  end
end
