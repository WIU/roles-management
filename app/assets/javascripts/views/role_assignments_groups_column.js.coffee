RolesManagement.Views.RoleAssignmentsGroupsColumn = Backbone.View.extend
  tagName: "div"
  id: "groups"
  className: "col-md-4"
  
  initialize: (options) ->
    @$el.html JST["templates/role_assignments/groups_column"]()

    @listenTo RolesManagement.groups, 'reset', @render
  
  render: ->
    console.debug 'Rendering groups column...'
    
    @$('#groups').empty()
    
    groupsEl = ''
    RolesManagement.groups.each (group) =>
      groupsEl += '<h2 style="font-weight: 300;">' + group.get('name') + '</h2><ul id="sortable" class="ui-sortable">'
      
      RolesManagement.groups.each (group) =>
        groupsEl += '<li class="ui-state-default">' + group.get('name') + '</li>'
        
      groupsEl += '</ul>'
    
    @$('#groups').append groupsEl
    @
