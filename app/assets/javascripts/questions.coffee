# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Question
  constructor: (el) ->
    @el = $(el)
    button = @el.find($('input[name="commit"]'))
    button.prop("disabled", true)
    button.val(button.data("disable-with"))

  toggle_informative: ->
    @el.next().toggle("slow")

  submit: ->
    @el.ajaxSubmit
      url: @el.attr("action")
      type: "POST"
      dataType: "script"
      data: @el.serialize()
      beforeSend: (jqXHR) =>
        token = $('meta[name="csrf-token"]').attr("content")
        jqXHR.setRequestHeader "X-CSRF-Token", token

  select_type: ->
    choice_button = $("[data-behavior='add_choice_fields']")
    #option_button = $("[data-behavior='add_option_fields']")
    image_button  = $("[data-behavior='add_image_fields']")
    rating_button  = $("[data-behavior='add_raiting_fields']")

    if @el.val() not in ["open", "date", "description", "phone", "email"]
      @el.closest("#question-modal").find(choice_button).removeClass("hidden")
      #if @el.val() == "7"
        #@el.closest(".question-fields").find(option_button).removeClass("hidden")
      #else
        #@el.closest(".question-fields").find(option_button).addClass("hidden")
        #@el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
        #@el.closest(".question-fields").find(".option-fields").hide()

      if @el.val() == "rating"
        @el.closest("#question-modal").find(rating_button).removeClass("hidden")

        @el.closest("#question-modal").find(choice_button).addClass("hidden")
        @el.closest("#question-modal").find(".choice-fields").find("input[type=hidden]").val("1")
        @el.closest("#question-modal").find(".choice-fields").hide()

        @el.closest("#question-modal").find(image_button).addClass("hidden")
        @el.closest("#question-modal").find(".image-fields:not(#info-img)").find("input[type=hidden]").val("1")
        @el.closest("#question-modal").find(".image-fields:not(#info-img)").hide()
      else
        @el.closest("#question-modal").find(rating_button).addClass("hidden")
        @el.closest("#question-modal").find(".rating-fields").find("input[type=hidden]").val("1")
        @el.closest("#question-modal").find(".rating-fields").hide()

      if @el.val() == "image"
        @el.closest("#question-modal").find(image_button).removeClass("hidden")
        #@el.closest(".question-fields").find(option_button).addClass("hidden")
        #@el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
        #@el.closest(".question-fields").find(".option-fields").hide()
        @el.closest("#question-modal").find(choice_button).addClass("hidden")
        @el.closest("#question-modal").find(".choice-fields").find("input[type=hidden]").val("1")
        @el.closest("#question-modal").find(".choice-fields").hide()

        @el.closest("#question-modal").find(rating_button).addClass("hidden")
        @el.closest("#question-modal").find(".rating-fields").find("input[type=hidden]").val("1")
        @el.closest("#question-modal").find(".rating-fields").hide()
      else
        @el.closest("#question-modal").find(image_button).addClass("hidden")
        @el.closest("#question-modal").find(".image-fields:not(#info-img)").find("input[type=hidden]").val("1")
        @el.closest("#question-modal").find(".image-fields:not(#info-img)").hide()
    else
      @el.closest("#question-modal").find(choice_button).addClass("hidden")
      @el.closest("#question-modal").find(".choice-fields").find("input[type=hidden]").val("1")
      @el.closest("#question-modal").find(".choice-fields").hide()
      #@el.closest(".question-fields").find(option_button).addClass("hidden")
      #@el.closest(".question-fields").find(".option-fields").find("input[type=hidden]").val("1")
      #@el.closest(".question-fields").find(".option-fields").hide()
      @el.closest("#question-modal").find(image_button).addClass("hidden")
      @el.closest("#question-modal").find(".image-fields:not(#info-img)").find("input[type=hidden]").val("1")
      @el.closest("#question-modal").find(".image-fields:not(#info-img)").hide()

      @el.closest("#question-modal").find(rating_button).addClass("hidden")
      @el.closest("#question-modal").find(".rating-fields").find("input[type=hidden]").val("1")
      @el.closest("#question-modal").find(".rating-fields").hide()

$(document).on "change", "[data-behavior='question_type']", (event) ->
  question = new Question @
  question.select_type()

$(document).on "submit", "[data-behavior~=submit-question]", (event) ->
  event.preventDefault()
  question = new Question @
  question.submit()

$(document).on "click", "[data-behavior='btn-informative']", (event) ->
  event.preventDefault()
  question = new Question @
  question.toggle_informative()

$(document).on "turbolinks:load", ->
  return unless $(".surveys.edit").length > 0
  $("#question-wrapper").sortable
    axis: "y"
    handle: ".handle"
    update: ->
      $.post($(this).data("sort-url"), $(this).sortable("serialize"))
