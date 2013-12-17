RolesManagement.Views.RoleAssignmentsColumn = Backbone.View.extend
  tagName: "div"
  className: "col-md-4"
  events:
    'click ul#sortable>li' : 'rowSelected'
  
  initialize: (options) ->
  
  render: ->
    @

  rowSelected: (e) ->
    row_uid = $(e.target).data('row-uid')
    console.debug "Row #{row_uid} was selected"
    $(e.target).addClass('ui-state-highlighted ui-state-selected')
    
    # Un-highlight other rows
    
    
    # Get related entities
    