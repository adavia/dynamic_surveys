# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("[data-behavior~=survey-dropzone]").dropzone
    success: (file, resp) ->
      $(".survey-images").prepend(resp.imagePartial)

