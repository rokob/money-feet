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

  load: (bindings) ->
    console.log("loading user")
    url = "/static/js/pymwyfa_stub.json"
    $.getJSON url, (stub) ->
        userData = stub.user_pages[bindings.id]
        html = App.renderTemplate "user-details.test", userData
        $('#content').html(html)

  teardown: () ->
    console.log("tearing down user")
}

Finch.route "/user/:uid/race/:rid", {
  setup: (bindings) ->
    console.log("setup for user:race #{bindings.uid}:#{bindings.rid}")

  load: (bindings) ->
    console.log "loading user:race"
    url = "/static/js/pymwyfa_stub.json"
    $.getJSON url, (stub) ->
      theData = stub.user_race_pages["#{bindings.uid}:#{bindings.rid}"]
      html = App.renderTemplate "user-race.test", theData
      $('#content').html(html)
  
  teardown: () ->
    console.log("tearing down user:race")
}

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
