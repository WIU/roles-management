window.RolesManagement =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  
  initialize: (data) ->
    @assignments = new Backbone.Collection()
    @roles = new Backbone.Collection()
    @groups = new Backbone.Collection()
    @people = new Backbone.Collection()
    @applications = new Backbone.Collection()
    
    #@current_user = new RolesManagement.Models.Entity data.current_user
    #@current_user.set 'admin', data.current_user_admin
    
    # Create a view state to be shared amongst all views
    #@view_state = new RolesManagement.Models.ViewState()
    
    @loadAssignments()
    
    @router = new RolesManagement.Routers.Applications()
    
    unless Backbone.history.started
      Backbone.history.start()
      Backbone.history.started = true
  
  loadAssignments: ->
    $.get( "/role_assignments.json", (assignments) =>
      assignments = []
      roles = []
      applications = []
      groups = []
      people = []
    
      _.each assignments, (assignment) =>
        assignments.push { id: assignment.id, entity_id: assignment.entity.id, role_id: assignment.role.id, parent_id: assignment.parent_id }
        roles.push { id: assignment.role.id, name: assignment.role.name, application_id: assignment.application.id }
        applications.push { id: assignment.application.id, name: assignment.application.name }
        if assignment.entity.type == 'Group'
          groups.push { id: assignment.entity.id, name: assignment.entity.name }
        else
          people.push { id: assignment.entity.id, name: assignment.entity.name } if assignment.entity.status
  
      RolesManagement.assignments.reset _.uniq(assignments, false, (i) -> i.id )
      RolesManagement.roles.reset _.uniq(roles, false, (i) -> i.id )
      RolesManagement.groups.reset _.uniq(groups, false, (i) -> i.id )
      RolesManagement.people.reset _.sortBy(_.uniq(people, false, (i) -> i.id ), (person) -> person.name)
      RolesManagement.applications.reset _.uniq(applications, false, (i) -> i.id )
    )
    .fail( () =>
      console.log( "Unable to load role assignments JSON!" )
    )
    
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
