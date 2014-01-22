window.RolesManagement =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  
  initialize: ->
    @assignments = new Backbone.Collection()
    @roles = new RolesManagement.Collections.Roles()
    #@groups = new RolesManagement.Collections.Groups()
    #@people = new Backbone.Collection()
    @applications = new Backbone.Collection()
    #@ous = new Backbone.Collection()
    
    # Load all data required for the main view
    @loadRoleAssignments()
    @loadApplications()
    @loadFavorites()
    @loadGroups()
    
    @router = new RolesManagement.Routers.Applications()
    
    unless Backbone.history.started
      Backbone.history.start()
      Backbone.history.started = true
  
  loadApplications: ->
    console.debug 'Loading applications (ownerships and operatorships) ...'
    
    $.get( "/applications.json", (applications_array) =>
      applications = []
      
      _.each applications_array, (application) =>
        console.log application
        applications.push { id: application.id, name: application.name }
      
      RolesManagement.applications.add _.uniq(applications, false, (i) -> i.id ), { merge: true }
      
      console.debug 'loadApplications', "Found #{RolesManagement.applications.length} applications"
    )
    .fail( () =>
      console.log( "Unable to load applications JSON!" )
    )
    
  loadFavorites: ->
    console.debug 'Loading favorites ...'
    
  loadGroups: ->
    console.debug 'Loading groups (ownerships and operatorships) ...'
    
  loadRoleAssignments: ->
    console.debug 'Loading role assignments ...'
    
    $.get( "/role_assignments.json", (role_assignments) =>
      assignments = []
    
      _.each role_assignments, (assignment) =>
        assignments.push { id: assignment.id, entity_id: assignment.entity_id, role_id: assignment.role_id, parent_id: assignment.parent_id }
  
      RolesManagement.assignments.add _.uniq(assignments, false, (i) -> i.id ), { merge: true }
      
      console.debug 'loadRoleAssignments', "Found #{RolesManagement.assignments.length} assignments"
    )
    .fail( () =>
      console.log( "Unable to load role assignments JSON!" )
    )
