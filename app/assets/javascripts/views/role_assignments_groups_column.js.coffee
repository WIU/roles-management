RolesManagement.Views.RoleAssignmentsGroupsColumn = Backbone.View.extend
  tagName: "div"
  id: "groups"
  className: "col-md-4"
  events:
    'click ul#sortable>li' : 'groupSelected'
  
  initialize: (options) ->
    @$el.html JST["templates/role_assignments/groups_column"]()

    @listenTo RolesManagement.groups, 'reset', @render
    @listenTo RolesManagement.ous, 'reset', @render
  
  render: ->
    console.debug 'Rendering groups column...'
    
    @$('#groups').empty()
    
    groupsEl = ''
    RolesManagement.ous.each (ou) =>
      groupsEl += '<h2 style="font-weight: 300;">' + ou.get('name') + '</h2><ul id="sortable" class="ui-sortable">'
      
      _.each RolesManagement.groups.findByOuId(ou.id), (group) =>
        groupsEl += '<li class="ui-state-default" data-group-id="' + group.id + '">' + group.get('name') + '</li>'
        
      groupsEl += '</ul>'
    
    # Add any unsorted (not assigned an OU) groups last
    unsorted_groups = RolesManagement.groups.findByOuId(null)
    if unsorted_groups.length
      groupsEl += '<h2 style="font-weight: 300;">Unsorted</h2><ul id="sortable" class="ui-sortable">'
  
      _.each unsorted_groups, (group) =>
        groupsEl += '<li class="ui-state-default" data-group-id="' + group.id + '">' + group.get('name') + '</li>'
    
      groupsEl += '</ul>'
    
    @$('#groups').append groupsEl
    @

  groupSelected: (e) ->
    group_id = $(e.target).data('group-id')
    console.debug "Group #{group_id} was selected"
    