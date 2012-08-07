Finch.route "/", {
  setup: () ->
    console.log("root is setup")
  
  load: () ->
    console.log("root is loaded")
    html = """
      <section><div class='well'>
        <h1>Hello Frank?</h1>
      </div></section>
    """
    $('#content').html(html)

  teardown: () ->
    console.log("root has been torndown")
}

Finch.route "/user/:id", {
  setup: (bindings) ->
    console.log("setup for user #{bindings.id}")
    App.setxClass "header-link", "li", "user", "active"

  load: (bindings) ->
    console.log("loading user")
    url = "/static/js/pymwyfa_stub.json"
    App.getResource url,
      stub: true
      stubtype: 'user_pages'
      stubid: bindings.id
      loc: '#content'
      tmpl: "user-details.test"

  teardown: () ->
    console.log("tearing down user")
}

Finch.route "/user/:uid/race/:rid", {
  setup: (bindings) ->
    console.log("setup for user:race #{bindings.uid}:#{bindings.rid}")
    App.setxClass "header-link", "li", "races", "active"

  load: (bindings) ->
    console.log "loading user:race"
    url = "/static/js/pymwyfa_stub.json"
    App.getResource url,
      stub: true
      stubtype: 'user_race_pages'
      stubid: "#{bindings.uid}:#{bindings.rid}"
      loc: '#content'
      tmpl: "user-race.test"
      postProcess: App.challenge.postProcess
  
  teardown: () ->
    console.log("tearing down user:race")
}

$ ->
  App = 
    cache: {}

    loadTemplate: (name) ->
      url = "/static/views/#{name}.handlebars"
      template = $.ajax({url: url, async: false}).responseText
      Handlebars.compile(template)
  
    renderTemplate: (name, data) ->
      self = this;
      # self.cache[name] = self.loadTemplate name if not self.cache[name]
      # self.cache[name](data || {})
      tmpl = self.loadTemplate name
      tmpl(data || {})

    getResource: (url, options) ->
      $.getJSON url, (data) ->
        if options.stub
          data = data[options.stubtype][options.stubid]
        html = App.renderTemplate options.tmpl, data
        $(options.loc).html(html)
        if options.postProcess
          options.postProcess data

    setxClass: (dataname, type, key, value) ->
      things = "data-#{dataname}"
      old = $("#{type}[#{things}][class=#{value}]")
      needle = $("#{type}[#{things}=#{key}]")
      old.removeClass(value)
      needle.addClass(value)

    challenge:
      postProcess: (data) ->
        App.challenge.slider parseInt(data.goal), c for c in data.challenges 
      slider: (goal, info) ->
        $("#slider-#{info.from}").slider
          value: goal
          min: goal-(7*info.unit)
          max: goal+(1*info.unit)
          step: info.unit
          slide: (event, ui) ->
            $("span[data-challenge-time='#{info.from}']").html(
              App.utility.secToStr ui.value
            )
            if ui.value < goal
              newamt = info.flat + info.bonus + (goal-ui.value)*info.scale/info.unit
            else
              newamt = info.flat
            $("span[data-challenge-amt='#{info.from}']").html newamt.toFixed 2

    utility:
      secToStr: (seconds) ->
        hours = Math.floor seconds/3600
        rem = seconds % 3600
        mins = Math.floor rem/60
        secs = rem % 60
        hourStr = if hours>0 then "#{hours}h" else ""
        minStr = if mins<10 then "0#{mins}m" else "#{mins}m"
        secStr = if secs<10 then "0#{secs}" else "#{secs}"
        "#{hourStr}#{minStr}#{secStr}s"

  window.App = App
