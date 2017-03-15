# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Filter
  constructor: (el) ->
    @el = $(el)

  add: ->
    time = new Date().getTime()
    regexp = new RegExp(@el.data("id"), "g")
    @el.parent().before(@el.data("fields").replace(regexp, time))

  remove: ->
    @el.prev("input[type=hidden]").val("1")
    @el.closest(".filter-fields").hide()

  show_choices: ->
    $.ajax "/alerts/update_choices",
      type: "GET"
      dataType: "script"
      data:
        question_id: $("option:selected", @el).val()
        question_type: $("option:selected", @el).data("type")

      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

$(document).on "click", "[data-behavior='add_alert_filter_fields']", (event) ->
  event.preventDefault()
  filter = new Filter @
  filter.add()

$(document).on "click", "[data-behavior='remove_filter_fields']", (event) ->
  event.preventDefault()
  filter = new Filter @
  filter.remove()

$(document).on "change", "[data-behavior~=alert_question_select]", (event) ->
  filter = new Filter @
  filter.show_choices()
