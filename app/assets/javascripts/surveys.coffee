# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("[data-behavior~=survey-dropzone]").dropzone
    autoProcessQueue: false
    parallelUploads: 4
    #params: {file: "file", name: "name"}
    init: ->
      submitBtn = $("#submit-images")
      dropFiles = @
      submitBtn.on "click", (event) =>
        event.preventDefault()
        dropFiles.processQueue()

      @on "addedfile", (file) ->
        unique = new Date().getTime()
        submitBtn.show()
        name = "<input data-id='#{unique}' type='text' name='#{$.trim(file.name.toLowerCase())}_#{unique}' placeholder='Img..' class='form-control img-drop-input'>"
        file._fileName = Dropzone.createElement(name)
        file.previewElement.appendChild(file._fileName)

      @on "sending", (file, xhr, formData) ->
        name = file.previewElement.querySelector("input[type='text']")
        formData.append("name", $(name).val())

    success: (file, resp) ->
      $(".survey-images").prepend(resp.imagePartial)

