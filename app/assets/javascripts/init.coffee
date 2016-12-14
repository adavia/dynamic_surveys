class Init
  constructor: (el) ->
    @el = $(el)

  add_name: ->
    @el.closest(".image-fields").find(".file-name").text(@el.val().split('\\').pop())

$(document).on "change", ":file", (event) ->
  init = new Init @
  init.add_name()
