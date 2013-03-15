DssRm.Models.ViewState = Backbone.Model.extend(
  initialize: ->
    @deselectAll()

  getSelectedRole: ->
    @get('selected_application').roles.where(id: parseInt(@get 'selected_role_id'))[0] if @get('selected_role_id') and @get('selected_application')
  
  deselectAll: ->
    @set selected_application: null
    @set selected_role_id: null
    @set focused_application_id: null
    @set focused_entity_id: null
)
