# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Choice
  constructor: (el) ->
    @el = $(el)

  add: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data("id"), "g")
    @el.parent().before(@el.data("fields").replace(regexp, time))

  remove: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".choice-fields").hide()

$(document).on "click", "[data-behavior='add_choice_fields']", (event) ->
  event.preventDefault()
  choice = new Choice @
  choice.add()

$(document).on "click", "[data-behavior='remove_choice_fields']", (event) ->
  event.preventDefault()
  choice = new Choice @
  choice.remove()
