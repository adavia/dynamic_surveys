# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Image
  constructor: (el) ->
    @el = $(el)

  add: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data("id"), "g")
    @el.parent().before(@el.data("fields").replace(regexp, time))

  remove: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".image-fields").hide()

$(document).on "click", "[data-behavior='add_image_fields']", (event) ->
  event.preventDefault()
  image = new Image @
  image.add()

$(document).on "click", "[data-behavior='remove_image_fields']", (event) ->
  event.preventDefault()
  image = new Image @
  image.remove()
