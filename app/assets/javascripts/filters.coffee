# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Filter
  constructor: (el) ->
    @el = $(el)

  show_choices: ->
    $.ajax "/alert_filters/update_choices",
      type: "GET"
      dataType: "script"
      data:
        question_id: $("option:selected", @el).val()
        question_type: $("option:selected", @el).data("type")

      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

$(document).on "change", "[data-behavior~=alert_question_select]", (event) ->
  filter = new Filter @
  filter.show_choices()
