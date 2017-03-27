class Pagination
  loadResults: ->
    $(window).on 'scroll', ->
      res = $('#scrolling-content a').attr('href')
      if res && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('#scrolling-content').html('<i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw"></i>')
        $.getScript res

  changePage: (el)->
    @el = $(el)
    $.getScript(@el.attr("href"))


$(document).on "turbolinks:load", ->
  return unless $(".surveys.images").length > 0 && $('#scrolling-content').length > 0
  pag = new Pagination
  pag.loadResults()


$(document).on "click", ".ajax-pag a", (event) ->
  event.preventDefault()
  pag = new Pagination
  pag.changePage(@)
