$ ->
  # Application
  App = Em.Application.create
    rootElement: '#content'

  App.Router = Em.Router.extend
    enableLogging: true
    location: 'hash'

    root: Em.Route.extend
      goToUser: Em.route.transitionTo('user')

      index: Em.Route.extend
        route: '/'
        redirectsTo: 'users'
      
      users: Em.Route.extend
        route: '/user'
        index: Em.Route.extend
          route: '/'
        user: Em.Route.extend
          route: '/:id'
          connectOutlets: (router, context) ->
            route.get('applicationController').connectOutlet App.UserDetailsView,
              App.userController.loadUser context.id
             
  # Models
  App.User = Em.Object.extend
    id: ''
    full_name: ''
    disp_name: ''
    charities: []
    races: []
    img: null

  # Views
  App.ApplicationView = Ember.View.extend
    templateName: 'application'

  App.UserDetailsView = Em.View.extend
    template: Handlebars.compile (
      $.ajax
        url: "/static/views/user-details.ember.handlebars"
        async: false
      .responseText
    )

  # Controllers
  App.ApplicationController = Em.Controller.extend()

  App.userController = Em.ObjectController.extend
    content: null
    loadUser: (id)->
      me = this
      url = "/static/js/pymwyfa_stub.json?v=#{id}"
      $.getJSON url, (data) ->
        me.set 'content', null
        userData = data.user_pages[id].info
        u = App.User.create userData
        me.set 'content', u


  window.App = App

  App.initialize()
