$ ->
  # photos
  $('.stream-buttons').on 'click', (e)->
    target = $(e.target)
    if e.target.tagName == 'SPAN'
      target.remove()
    else if target.hasClass('active')
      target.children('span').remove()
    else
      target.prepend '<span>✔</span>'
