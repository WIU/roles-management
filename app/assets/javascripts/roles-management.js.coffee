window.RolesManagement =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  
  initialize: ->
    @assignments = new RolesManagement.Collections.RoleAssignments()
    @roles = new RolesManagement.Collections.Roles()
    @entities = new RolesManagement.Collections.Entities()
    @applications = new RolesManagement.Collections.Applications()
    
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
      entities = []
      roles = []
      
      _.each applications_array, (application) =>
        operator_ids = []
        _.each application.operators, (operator) ->
          entities.push { id: operator.id, name: operator.name, type: operator.type }
          operator_ids.push operator.id

        owner_ids = []
        _.each application.owners, (owner) ->
          entities.push { id: owner.id, name: owner.name, type: owner.type }
          owner_ids.push owner.id
        
        role_ids = []
        _.each application.roles, (role) ->
          roles.push { id: role.id, name: role.name }
          role_ids.push role.id
        
        applications.push { id: application.id, name: application.name, operator_ids: operator_ids, owner_ids: owner_ids, role_ids: role_ids }
      
      # Use .add {merge: true} instead of replace as we may be receiving piecemeal information
      # from the various load* functions.
      RolesManagement.applications.add _.uniq(applications, false, (i) -> i.id ), { merge: true }
      RolesManagement.roles.add _.uniq(roles, false, (i) -> i.id ), { merge: true }
      RolesManagement.entities.add _.uniq(entities, false, (i) -> i.id ), { merge: true }
      
      console.debug 'loadApplications', "Found #{applications.length} applications"
      console.debug 'loadApplications', "Found #{roles.length} roles"
      console.debug 'loadApplications', "Found #{entities.length} entities"
    )
    .fail( () =>
      console.log( "Unable to load applications JSON!" )
    )
    
  loadFavorites: ->
    console.debug 'Loading favorites ...'
    
  loadGroups: ->
    console.debug 'Loading groups (ownerships and operatorships) ...'
    
    $.get( "/groups.json", (groups_array) =>
      groups = []
      entities = []
      
      _.each groups_array, (group) =>
        member_ids = []
        _.each group.members, (member) ->
          entities.push { id: member.id, name: member.name, type: member.type }
          member_ids.push member.id
        
        groups.push { id: group.id, name: group.name, description: group.description, member_ids: member_ids, type: 'Group' }
      
      # Use .add {merge: true} instead of replace as we may be receiving piecemeal information
      # from the various load* functions.
      RolesManagement.entities.add _.uniq(groups, false, (i) -> i.id ), { merge: true }
      RolesManagement.entities.add _.uniq(entities, false, (i) -> i.id ), { merge: true }
      
      console.debug 'loadGroups', "Found #{groups.length} groups"
      console.debug 'loadGroups', "Found #{entities.length} entities"
    )
    .fail( () =>
      console.log( "Unable to load groups JSON!" )
    )
    
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
