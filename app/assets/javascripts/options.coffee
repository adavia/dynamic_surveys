# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Option
  constructor: (el) ->
    @el = $(el)

  add: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data("id"), "g")
    @el.parent().before(@el.data("fields").replace(regexp, time))

  remove: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".option-fields").hide()

$(document).on "click", "[data-behavior='add_option_fields']", (event) ->
  event.preventDefault()
  option = new Option @
  option.add()

$(document).on "click", "[data-behavior='remove_option_fields']", (event) ->
  event.preventDefault()
  option = new Option @
  option.remove()
