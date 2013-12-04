RolesManagement.Views.RoleAssignmentsPermissionsColumn = Backbone.View.extend
  tagName: "div"
  id: "permissions"
  className: "col-md-4"
  
  initialize: (options) ->
    @$el.html JST["templates/role_assignments/permissions_column"]()

    # # Set up "peopleGroups" (people sliced into groups based on names) for the view
    # @peopleGroups = new Backbone.Collection() # stores RolesManagement.people sliced into labeled groups for the view
    # @listenTo RolesManagement.people, 'reset', => @peopleGroups.reset sliceWithLabels(RolesManagement.people)
    # 
    # @listenTo @peopleGroups, 'reset', @render
  
  render: ->
    @
