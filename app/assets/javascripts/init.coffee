class Init
  constructor: (el) ->
    @el = $(el)

  preview_image: ->
    if typeof FileReader != "undefined"
      regex = /^([a-zA-Z0-9\s_\\.\-:])+(.jpg|.jpeg|.gif|.png|.bmp)$/
      if regex.test(@el[0].files[0].name.toLowerCase())
        reader = new FileReader
        reader.onload = (e) =>
          @el.closest(".image-fields").find(".img-preview").css("background-image", "url(#{e.target.result})")
        reader.readAsDataURL @el[0].files[0]
      else
        alert "#{@el[0].files[0].name} is not a valid image file"
    else
      alert "This browser does not support HTML5 FileReader"

$(document).on "change", ":file", (event) ->
  init = new Init @
  init.preview_image()

$(document).on "hidden.bs.modal", ".modal", (event) ->
  $(@).remove()

$(document).on "click", "[data-behavior~=date-picker]", (event) ->
  $(@).datetimepicker({format: 'DD/MM/YYYY', locale: moment.locale($("body").data("locale"))}).datetimepicker("show");

Dropzone.autoDiscover = false
