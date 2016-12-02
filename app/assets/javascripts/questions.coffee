# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Question
  constructor: (el) ->
    @el = $(el)

  add: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data("id"), "g")
    @el.parent().before(@el.data("fields").replace(regexp, time))

  remove: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".question-fields").hide()

  select_type: ->
    answser_button = $("[data-behavior='add_answer_fields']")
    option_button = $("[data-behavior='add_option_fields']")

    types = ["open", "date", "raiting"]

    if @el.val() not in types
      @el.closest(".question-fields").find(answser_button).removeClass("hidden")
      if @el.val() == "values"
        @el.closest(".question-fields").find(option_button).removeClass("hidden")
      else
        @el.closest(".question-fields").find(option_button).addClass("hidden")
    else
      @el.closest(".question-fields").find(answser_button).addClass("hidden")
      @el.closest(".question-fields").find(option_button).addClass("hidden")
      @el.closest(".question-fields").find(".answer-fields").find("input[type=hidden]").val("1")
      @el.closest(".question-fields").find(".answer-fields").hide()
      @el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
      @el.closest(".question-fields").find(".option-fields").hide()

    if @el.val() != "image"
      @el.closest(".question-fields").find(".btn-file").addClass("hidden")
    else
      @el.closest(".question-fields").find(".btn-file").removeClass("hidden")

$(document).on "click", "[data-behavior='add_question_fields']", (event) ->
  event.preventDefault()
  question = new Question @
  question.add()

$(document).on "click", "[data-behavior='remove_question_fields']", (event) ->
  event.preventDefault()
  question = new Question @
  question.remove()
