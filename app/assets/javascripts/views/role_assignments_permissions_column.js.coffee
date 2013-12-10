RolesManagement.Views.RoleAssignmentsPermissionsColumn = Backbone.View.extend
  tagName: "div"
  id: "permissions"
  className: "col-md-4"
  
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
        permissionsEl += '<li class="ui-state-default">' + role.get('name') + '</li>'
        
      permissionsEl += '</ul>'
    
    @$('#permissions').append permissionsEl
    @
