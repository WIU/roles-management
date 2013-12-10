window.RolesManagement =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  
  initialize: ->
    @assignments = new Backbone.Collection()
    @roles = new RolesManagement.Collections.Roles()
    @groups = new RolesManagement.Collections.Groups()
    @people = new Backbone.Collection()
    @applications = new Backbone.Collection()
    @ous = new Backbone.Collection()
    
    @loadAssignments() # loads the main data displayed in RolesManagement
    
    @router = new RolesManagement.Routers.Applications()
    
    unless Backbone.history.started
      Backbone.history.start()
      Backbone.history.started = true
  
  loadAssignments: ->
    console.debug 'Loading role assignments ...'
    $.get( "/role_assignments.json", (role_assignments) =>
      assignments = []
      roles = []
      applications = []
      groups = []
      people = []
      ous = []
    
      _.each role_assignments, (assignment) =>
        assignments.push { id: assignment.id, entity_id: assignment.entity.id, role_id: assignment.role.id, parent_id: assignment.parent_id }
        roles.push { id: assignment.role.id, name: assignment.role.name, application_id: assignment.application.id }
        applications.push { id: assignment.application.id, name: assignment.application.name }
        if assignment.entity.type == 'Group'
          groups.push { id: assignment.entity.id, name: assignment.entity.name, ou_id: assignment.entity.ou_id }
          ous.push { id: assignment.entity.ou_id, name: assignment.entity.ou_name }
        else
          people.push { id: assignment.entity.id, name: assignment.entity.name } if assignment.entity.status
  
      RolesManagement.assignments.reset _.uniq(assignments, false, (i) -> i.id )
      RolesManagement.roles.reset _.uniq(roles, false, (i) -> i.id )
      RolesManagement.groups.reset _.uniq(groups, false, (i) -> i.id )
      RolesManagement.people.reset _.sortBy(_.uniq(people, false, (i) -> i.id ), (person) -> person.name)
      RolesManagement.applications.reset _.uniq(applications, false, (i) -> i.id )
      RolesManagement.ous.reset _.uniq(ous, false, (i) -> i.id )
      
      console.debug 'loadAssignments', "Found #{RolesManagement.assignments.length} assignments"
      console.debug 'loadAssignments', "Found #{RolesManagement.roles.length} roles"
      console.debug 'loadAssignments', "Found #{RolesManagement.groups.length} groups"
      console.debug 'loadAssignments', "Found #{RolesManagement.people.length} people"
      console.debug 'loadAssignments', "Found #{RolesManagement.applications.length} applications"
      console.debug 'loadAssignments', "Found #{RolesManagement.ous.length} ous"
    )
    .fail( () =>
      console.log( "Unable to load role assignments JSON!" )
    )
