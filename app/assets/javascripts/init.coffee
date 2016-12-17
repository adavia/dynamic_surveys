class Init
  constructor: (el) ->
    @el = $(el)

  add_name: ->
    @el.closest(".image-fields").find(".file-name").text(@el.val().split('\\').pop())

  navigate_to: ->
    window.location.replace(@el.data("link"));

$(document).on "change", ":file", (event) ->
  init = new Init @
  init.add_name()

$(document).on "click", "[data-behavior~=datalink]", (event) ->
  init = new Init @
  init.navigate_to()
  event.preventDefault()
