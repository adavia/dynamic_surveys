# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Submission
  constructor: (el) ->
    @el = $(el)

  show: ->
    $.ajax
      url: @el.attr("href")
      method: "GET"
      dataType: "html"
      success: (data, textStatus, jqXHR) =>
        @el.closest(".modal-item").next().html($(data).find(".submitted-answers"))
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

  show_choices: ->
    $.ajax "/submissions/update_choices",
      type: "GET"
      dataType: "script"
      data: {
        question_id: $("[data-behavior~=questions_select] option:selected").val()
        question_type: $("[data-behavior~=questions_select] option:selected").data("type")
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

$(document).on "click", "[data-behavior~=submission-show]", (event) ->
  submission = new Submission @
  submission.show()
  event.preventDefault()


$(document).on "change", "[data-behavior~=questions_select]", (event) ->
  submission = new Submission @
  submission.show_choices()
