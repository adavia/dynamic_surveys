# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Customer
  constructor: (el) ->
    @el = $(el)

  show: ->
    $.ajax
      url: @el.attr("href")
      method: "GET"
      dataType: "script"
      beforeSend: ->
        $("#customer-loader").show()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")

$(document).on "click", "[data-behavior~=load-customer-dropdown]", (event) ->
  customer = new Customer @
  customer.show()
  event.preventDefault()

