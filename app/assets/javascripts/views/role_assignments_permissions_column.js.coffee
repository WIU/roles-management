RolesManagement.Views.RoleAssignmentsPermissionsColumn = RolesManagement.Views.RoleAssignmentsColumn.extend
  id: "permissions"
  
  initialize: (options) ->
    @$el.html JST["templates/role_assignments/permissions_column"]()

    @listenTo RolesManagement.applications, 'reset', @render
  
  render: ->
    console.debug 'Rendering permissions column...'
    
    @$('#permissions').empty()
    
    permissionsEl = ''
    RolesManagement.applications.each (application) =>
      permissionsEl += '<h2 style="font-weight: 300;">' + application.get('name') + '</h2><ul id="sortable" class="ui-sortable">'
      
      _.each RolesManagement.roles.findByApplicationId(application.id), (role) =>
        permissionsEl += '<li class="ui-state-default" data-row-uid="' + role.cid + '">' + role.get('name') + '</li>'
        
      permissionsEl += '</ul>'
    
    @$('#permissions').append permissionsEl
    @
