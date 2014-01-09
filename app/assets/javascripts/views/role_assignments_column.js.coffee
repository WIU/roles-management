RolesManagement.Views.RoleAssignmentsColumn = Backbone.View.extend
  tagName: "div"
  className: "col-md-4"
  events:
    'click ul#sortable>li'       : 'rowSelected'
    'click span#new-entry'       : 'revealNewEntryForm'
    'submit form#new-entry-form' : 'submitNewEntryForm'
    'blur form#new-entry-form'   : 'blurNewEntryForm'
  
  initialize: (options) ->
  
  render: ->
    @

  rowSelected: (e) ->
    row_uid = $(e.target).data('row-uid')
    console.debug "Row #{row_uid} was selected"
    $(e.target).addClass('ui-state-highlighted ui-state-selected')
    
    # Un-highlight other rows
    
    
    # Get related entities
    
  revealNewEntryForm: (e) ->
    @$('.new-entry-box').addClass 'active'
    @$('.new-entry-box input').val('')
    @$('.new-entry-box input').focus()
  
  submitNewEntryForm: (e) ->
    value = $(e.currentTarget).children('input').first().val()
    
    @handleNewEntry(value) if @handleNewEntry?
    
    # Return false to avoid submitting the New Entry form
    false
  
  blurNewEntryForm: (e) ->
    @$('.new-entry-box').removeClass 'active'
  