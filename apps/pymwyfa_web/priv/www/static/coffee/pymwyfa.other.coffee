Handlebars.registerHelper 'formatTime', (context) ->
  mask = "ddd mmm dd yyyy HH:MM"
  dateFormat(context, mask)

Handlebars.registerHelper 'secsToTime', (cxt) ->
  App.utility.secToStr(cxt)
