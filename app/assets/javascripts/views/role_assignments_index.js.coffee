RolesManagement.Views.RoleAssignmentsIndex = Backbone.View.extend
  tagName: "div"
  id: "role_assignments_index"
  className: "row"
  
  initialize: (options) ->
    @$el.html JST["templates/role_assignments/index"]()
    
    @peopleColumn = new RolesManagement.Views.RoleAssignmentsPeopleColumn()
    @groupsColumn = new RolesManagement.Views.RoleAssignmentsGroupsColumn()
    @permissionsColumn = new RolesManagement.Views.RoleAssignmentsPermissionsColumn()
  
  render: ->
    # Subviews render themselves on-demand (via event listening)
    @$('#people').replaceWith @peopleColumn.el
    @$('#groups').replaceWith @groupsColumn.el
    @$('#permissions').replaceWith @permissionsColumn.el
    @
