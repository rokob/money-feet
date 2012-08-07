(($) ->
  router = null

  # User
  UserView = Backbone.View.extend
    events:
      'click a.support': 'supportTest'

    initialize: (spec) ->
      raceCollection = spec.model.get 'races'
      charityCollection = spec.model.get 'charities'
      if raceCollection.length > 0
        this.races = new RaceCollectionView
          model: raceCollection
      if charityCollection.length > 0
        this.charities = new CharityCollectionView
          model: charityCollection

    supportTest: (e) ->
      e.preventDefault()
      $(e.target).fadeOut(500)
      setTimeout () ->
        router.navigate e.target.hash,
          trigger: true
          replace: false
      , 600

    render: () ->
      self = this
      html = $ router.renderTemplate 'user-details.bb', self.model.toJSON()
      $(self.el).html(html)
      if self.races
        $(self.el).append self.races.render
          is_current: self.model.get 'is_current'
          user_id: self.model.get 'id'
      if self.charities
        $(self.el).append self.charities.render
          is_current: self.model.get 'is_current'
          user_id: self.model.get 'id'
          user_name: self.model.get 'name'
      self.el

  UserModel = Backbone.Model.extend
    toJSON: () ->
      is_current: this.get 'is_current'
      id: this.get 'id'
      name: this.get 'name'
      img: this.get 'img'
      
    initialize: (spec) ->
      this.set 'id', spec.user.id
      this.set 'name', spec.user.name
      this.set 'first_name', spec.user.first_name
      this.set 'last_name', spec.user.last_name
      this.set 'img', spec.user.img
      if spec.races
        this.set('races', new RaceCollection $.map spec.races, (s) -> new RaceModel s)
      if spec.charities
        this.set('charities', new CharityCollection $.map spec.charities, (s) ->
          new CharityModel s)

  # Race
  RaceModel = Backbone.Model.extend
    initialize: (spec) ->
      this.set 'id', spec.id
      this.set 'name', spec.name
      this.set 'location', spec.location
      this.set 'lat', spec.lat
      this.set 'lng', spec.lng
      this.set 'distance', spec.distance
      this.set 'units', spec.units
      this.set 'datetime', spec.datetime
      this.set 'url', spec.url
      this.set 'img', spec.img
      this.set 'blurb', spec.blurb

  RaceCollection = Backbone.Collection.extend
    model: RaceModel

  RaceCollectionView = Backbone.View.extend
    render: (data) ->
      self = this
      data = $.extend data, 
        races: self.model.toJSON()
      html = $ router.renderTemplate 'race-list.bb', data
      $(self.el).html html
      self.el

  # Charity
  CharityModel = Backbone.Model.extend
    initialize: (spec) ->
      this.set 'id', spec.id
      this.set 'name', spec.name
      this.set 'img', spec.img
      this.set 'url', spec.url
      this.set 'blurb', spec.blurb
  
  CharityCollection = Backbone.Collection.extend
    model: CharityModel

  CharityCollectionView = Backbone.View.extend
    render: (data) ->
      data = $.extend data,
        charities: this.model.toJSON()
      html = $ router.renderTemplate 'charity-list.bb', data
      $(this.el).html html
      this.el

  # Challenge
  ChallengeModel = Backbone.Model.extend
    initialize: (spec) ->
      this.set 'from_id', spec.from
      this.set 'from_name', spec.from_name
      this.set 'to_id', spec.to
      this.set 'race', new RaceModel spec.race
      this.set 'flat', spec.flat
      this.set 'bonus', spec.bonus
      this.set 'scale', spec.scale
      this.set 'unit', spec.unit
      this.set 'charity_id', spec.charity

  ChallengeCollection = Backbone.Collection.extend
    model: ChallengeModel

  ChallengeCollectionView = Backbone.View.extend
    render: (data) ->
      data = $.extend data,
        challenges: this.model.toJSON()
      html = $ router.renderTemplate 'challenge-list.bb', data
      $(this.el).html html
      this.el

  # Running
  RunningModel = Backbone.Model.extend
    initialize: (spec) ->
      this.set 'user', new UserModel 
        user: spec.user
      this.set 'race', new RaceModel spec.race
      this.set 'goal', spec.goal
      this.set 'result', spec.result
      this.set 'bib', spec.bib
      this.set 'challenges', new ChallengeCollection $.map spec.challenges, \
      (s) -> new ChallengeModel s
      this.set 'charities', new CharityCollection $.map spec.charities, \
      (s) -> new CharityModel s
    
    toJSON: () ->
      user: (this.get 'user').toJSON()
      race: (this.get 'race').toJSON()
      is_current: this.get 'is_current'
      goal: this.get 'goal'
      result: this.get 'result'
      bib: this.get 'bib'

  RunningView = Backbone.View.extend
    initialize: (spec) ->
      challengeCollection = spec.model.get 'challenges'
      charityCollection = spec.model.get 'charities'
#      if challengeCollection.length > 0
      this.challenges = new ChallengeCollectionView
        model: challengeCollection
      if charityCollection.length > 0
        this.charities = new CharityCollectionView
          model: charityCollection

    render: () ->
      self = this
      html = $ router.renderTemplate 'running.bb', self.model.toJSON()
      $(self.el).html html
      if self.challenges
        self.$('#data-challenge-list').html self.challenges.render
          is_current: self.model.get 'is_current'
      App.challenge.postProcess
        goal: self.model.get 'goal'
        elem: self.$('#slider-finish')
        donationEl:  self.$("#expected-donation")
        infoEls:  self.$("span.data-challenge-info")
      if self.charities
        $(self.el).append self.charities.render
          is_current: self.model.get 'is_current'
          user_name: (self.model.get 'user').get 'name'
      self.el

  window.AppRouter = Backbone.Router.extend
    routes:
      'login': 'login'
      'user/:id': 'userHome'
      'user/:uid/race/:rid': 'userRace'
      '': 'home'

    setView: (view, title) ->
      html = view.render()
      $('#content').html html

      newTitle = 'PYMWYFA'
      if !!title and title.length > 0
        newTitle += " - #{title}"
      document.title = newTitle

    logout: () ->
      self = this
      $.post "/logout", () ->
        location.reload()

    login: () ->
      if not this.isUserSignedIn()
        view = new LoginView()
        this.setView view, "Login"
      else
        this.home()

    home: () ->
      if this.isUserSignedIn()
        this.navigate "user/#{this.currentUserId}",
          trigger: true
          replace: true
      else
        this.navigate "login",
          trigger: true
          replace: true

    userHome: (id) ->
      self = this
      App.utility.setxClass "header-link", "li", "user", "active"
      $.getJSON "/static/js/pymwyfa_stub.json", (stub) ->
        user = stub.user_pages[id]
        user.is_current = self.currentUserId is id
        model = new UserModel user
        view = new UserView
          model: model
        self.setView view, model.get 'name'

    userRace: (uid, rid) ->
      self = this
      App.utility.setxClass "header-link", "li", "races", "active"
      $.getJSON "/static/js/pymwyfa_stub.json", (stub) ->
        userrace = stub.user_race_pages["#{uid}:#{rid}"]
        userrace.is_current = self.currentUserId is userrace.user.id
        model = new RunningModel userrace
        view = new RunningView
          model: model
        self.setView view, "Race Details"

    loadTemplate: (name) ->
      url = "/views/#{name}.handlebars?v=#{Math.floor(100*Math.random())+1}"
      template = $.ajax
        url: url
        async: false
      .responseText
      Handlebars.compile template

    renderTemplate: (name, data) ->
      self = this
      # put the cache here
      tmpl = self.loadTemplate name
      tmpl data or {}

    isUserSignedIn: () ->
      this.currentUserId isnt null and this.currentUserId isnt undefined \
      and this.currentUserId isnt 0

    start: (userId) ->
      this.currentUserId = userId
      router = this

      Backbone.history.start()

      $(".logout").click (e) ->
        e.preventDefault()
        router.logout()

      hash = window.location.hash
      if hash is '' or hash is '#'
        if not userId
          this.navigate 'login',
            trigger: true
            replace: true
        else
          this.navigate "user/#{userId}",
            trigger: true
            replace: true

  window.App = 

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
      setxClass: (dataname, type, key, value) ->
        things = "data-#{dataname}"
        old = $("#{type}[#{things}][class=#{value}]")
        needle = $("#{type}[#{things}=#{key}]")
        old.removeClass(value)
        needle.addClass(value)

    challenge:
      postProcess: (data) ->
        flatz = $.map data.infoEls, (el) ->
          flat: parseInt $(el).attr("data-challenge-f")
        finalamt = _.foldl flatz, (a, c) ->
          a + c.flat
        , 0
        data.donationEl.html finalamt.toFixed 2
        App.challenge.slider parseInt(data.goal), data.elem, \
          data.infoEls, data.donationEl
          
      slider: (goal, elem, infoels, donationEl) ->
        if goal < 3600
          step = 1
          max = goal+5
          min = goal-120
        else
          step = 30
          max = goal+60
          min = goal-900
        elem.slider
          value: goal
          min: min
          max: max
          step: step
          slide: (event, ui) ->
            challenges = $.map infoels, (el) ->
              from: $(el).attr("data-challenge-from")
              bonus: parseInt $(el).attr("data-challenge-b")
              flat: parseInt $(el).attr("data-challenge-f")
              scale: parseInt $(el).attr("data-challenge-s")
              unit: parseInt $(el).attr("data-challenge-u")
            $("#expected-finish").html App.utility.secToStr ui.value
            donationEl.html 0
            $.map challenges, (c) ->
              newamt = c.flat
              if ui.value < goal
                newamt = newamt + c.bonus + (goal-ui.value)*c.scale/c.unit
              $("span[data-challenge-amt='#{c.from}']").html newamt.toFixed 2
              donationEl.html (parseFloat(donationEl.html()) + newamt).toFixed 2

)(jQuery)
