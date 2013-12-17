RolesManagement.Views.RoleAssignmentsRow = Backbone.View.extend
  tagName: "li"
  className: "ui-state-default"
  events:
    'click' : 'rowSelected'
  
  initialize: (options) ->
  
  render: ->
    @

  rowSelected: (e) ->
    row_uid = $(e.target).data('row-uid')
    console.debug "Row #{row_uid} was selected"
    $(e.target).addClass('ui-state-highlighted ui-state-selected')
    
    # Un-highlight other rows
    
    
    # Get related entities
    