window.RolesManagement =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  
  initialize: (data) ->
    #@applications = new RolesManagement.Collections.Applications data.applications
    
    #@current_user = new RolesManagement.Models.Entity data.current_user
    #@current_user.set 'admin', data.current_user_admin
    
    # Create a view state to be shared amongst all views
    #@view_state = new RolesManagement.Models.ViewState()
    
    @router = new RolesManagement.Routers.Applications()
    
    unless Backbone.history.started
      Backbone.history.start()
      Backbone.history.started = true
    
    # Enable tooltips globally
    # $("body").tooltip
    #   selector: '[rel=tooltip]'
    
    # Prevent body scrolling when modal is open
  #   $("body").on "shown", (e) ->
  #     class_attr = $(e.target).attr('class')
  #     if class_attr and class_attr.indexOf("modal") != -1
  #       $("body").css('overflow', 'hidden')
  #   $("body").on "hidden", (e) ->
  #     class_attr = $(e.target).attr('class')
  #     if class_attr and class_attr.indexOf("modal") != -1
  #       $("body").css('overflow', 'visible')
  # 
  # admin_logged_in: ->
  #   RolesManagement.current_user.get 'admin'
