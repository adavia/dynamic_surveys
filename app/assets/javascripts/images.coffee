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

  show_gallery: ->
    slide = @el.closest(".image-fields").find(".images-list")
    if !slide.data("loaded")
      slide.load(@el.attr("href"))
      slide.data("loaded", true)

    slide.slideToggle("slow")

  select_from_gallery: ->
    @el.closest(".image-fields").find(".img-preview").css("background-image", "url(#{@el.attr("src")})")
    @el.closest(".image-fields").find(".gallery-path").prop("disabled", false)
    @el.closest(".image-fields").find(".gallery-path").val(@el.attr("src"))
    @el.closest(".image-fields").find("#survey-img-name").val(@el.data("name"))
    @el.closest(".image-fields").find(".upload").prop("disabled", true)

$(document).on "click", "[data-behavior='add_image_fields']", (event) ->
  event.preventDefault()
  image = new Image @
  image.add()

$(document).on "click", "[data-behavior='remove_image_fields']", (event) ->
  event.preventDefault()
  image = new Image @
  image.remove()

$(document).on "click", "[data-behavior='show_gallery']", (event) ->
  event.preventDefault()
  image = new Image @
  image.show_gallery()

$(document).on "click", "[data-behavior='image_select']", (event) ->
  event.preventDefault()
  image = new Image @
  image.select_from_gallery()
