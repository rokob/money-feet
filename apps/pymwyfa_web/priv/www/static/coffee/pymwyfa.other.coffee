Handlebars.registerHelper 'formatTime', (context) ->
  dateFormat(context)

Handlebars.registerHelper 'secsToTime', (cxt) ->
  hours = Math.floor cxt/3600
  rem = cxt % 3600
  mins = Math.floor rem/60
  secs = rem % 60
  hourStr = if hours>0 then "#{hours}:" else ""
  minStr = if mins<10 then "0#{mins}:" else "#{mins}:"
  secStr = if secs<10 then "0#{secs}" else "#{secs}"
  "#{hourStr}#{minStr}#{secStr}"
