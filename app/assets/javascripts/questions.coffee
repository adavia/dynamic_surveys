# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Question
  constructor: (el) ->
    @el = $(el)

  add: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data("id"), "g")
    @el.closest("form").find("#question-wrapper").append(@el.data("fields").replace(regexp, time))
    $('input.question-position').each (idx) ->
      $(@).val(idx + 1)

  remove: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".question-fields").hide()

  remove_image: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".info-image-fields").hide()

  toggle_informative: ->
    @el.next().toggle("slow")

  select_type: ->
    choice_button = $("[data-behavior='add_choice_fields']")
    #option_button = $("[data-behavior='add_option_fields']")
    image_button  = $("[data-behavior='add_image_fields']")

    if @el.val() not in ["open", "date", "rating"]
      @el.closest(".question-fields").find(choice_button).removeClass("hidden")
      #if @el.val() == "7"
        #@el.closest(".question-fields").find(option_button).removeClass("hidden")
      #else
        #@el.closest(".question-fields").find(option_button).addClass("hidden")
        #@el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
        #@el.closest(".question-fields").find(".option-fields").hide()

      if @el.val() == "image"
        @el.closest(".question-fields").find(image_button).removeClass("hidden")
        #@el.closest(".question-fields").find(option_button).addClass("hidden")
        #@el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
        #@el.closest(".question-fields").find(".option-fields").hide()
        @el.closest(".question-fields").find(choice_button).addClass("hidden")
        @el.closest(".question-fields").find(".choice-fields").find("input[type=hidden]").val("1")
        @el.closest(".question-fields").find(".choice-fields").hide()
      else
        @el.closest(".question-fields").find(image_button).addClass("hidden")
        @el.closest(".question-fields").find(".image-fields").find("input[type=hidden]").val("1")
        @el.closest(".question-fields").find(".image-fields").hide()
    else
      @el.closest(".question-fields").find(choice_button).addClass("hidden")
      @el.closest(".question-fields").find(".choice-fields").find("input[type=hidden]").val("1")
      @el.closest(".question-fields").find(".choice-fields").hide()
      #@el.closest(".question-fields").find(option_button).addClass("hidden")
      #@el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
      #@el.closest(".question-fields").find(".option-fields").hide()
      @el.closest(".question-fields").find(image_button).addClass("hidden")
      @el.closest(".question-fields").find(".image-fields").find("input[type=hidden]").val("1")
      @el.closest(".question-fields").find(".image-fields").hide()

$(document).on "click", "[data-behavior='add_question_fields']", (event) ->
  event.preventDefault()
  question = new Question @
  question.add()

$(document).on "click", "[data-behavior='remove_question_fields']", (event) ->
  event.preventDefault()
  question = new Question @
  question.remove()

$(document).on "change", "[data-behavior='question_type']", (event) ->
  question = new Question @
  question.select_type()

$(document).on "turbolinks:load", ->
  return unless $(".surveys.edit").length > 0 || $(".surveys.new").length > 0
  $("#question-wrapper").sortable
    axis: "y"
    handle: ".handle"
    stop: (event, ui) ->
      $('input.question-position').each (idx) ->
        $(@).val(idx + 1)

$(document).on "click", "[data-behavior='remove_info_image_fields']", (event) ->
  event.preventDefault()
  question = new Question @
  question.remove_image()

$(document).on "click", "[data-behavior='btn-informative']", (event) ->
  event.preventDefault()
  question = new Question @
  question.toggle_informative()
