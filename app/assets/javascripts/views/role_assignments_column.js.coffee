RolesManagement.Views.RoleAssignmentsColumn = Backbone.View.extend
  tagName: "div"
  className: "col-md-4"
  events:
    'click ul#sortable>li' : 'rowSelected'
  
  initialize: (options) ->
    # @$el.html JST["templates/role_assignments/groups_column"]()
    # 
    # @listenTo RolesManagement.groups, 'reset', @render
    # @listenTo RolesManagement.ous, 'reset', @render
  
  render: ->
    # console.debug 'Rendering groups column...'
    # 
    # @$('#groups').empty()
    # 
    # groupsEl = ''
    # RolesManagement.ous.each (ou) =>
    #   groupsEl += '<h2 style="font-weight: 300;">' + ou.get('name') + '</h2><ul id="sortable" class="ui-sortable">'
    #   
    #   _.each RolesManagement.groups.findByOuId(ou.id), (group) =>
    #     groupsEl += '<li class="ui-state-default" data-group-id="' + group.id + '">' + group.get('name') + '</li>'
    #     
    #   groupsEl += '</ul>'
    # 
    # # Add any unsorted (not assigned an OU) groups last
    # unsorted_groups = RolesManagement.groups.findByOuId(null)
    # if unsorted_groups.length
    #   groupsEl += '<h2 style="font-weight: 300;">Unsorted</h2><ul id="sortable" class="ui-sortable">'
    #   
    #   _.each unsorted_groups, (group) =>
    #     groupsEl += '<li class="ui-state-default" data-group-id="' + group.id + '">' + group.get('name') + '</li>'
    # 
    #   groupsEl += '</ul>'
    # 
    # @$('#groups').append groupsEl
    @

  rowSelected: (e) ->
    row_uid = $(e.target).data('row-uid')
    console.debug "Row #{row_uid} was selected"
    $(e.target).addClass('ui-state-highlighted ui-state-selected')
    