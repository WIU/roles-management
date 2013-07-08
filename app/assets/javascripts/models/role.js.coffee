DssRm.Models.Role = Backbone.Model.extend(
  urlRoot: "/roles"
  
  initialize: ->
    console.log "initializing new role #{@cid}"
    @resetNestedCollections()
    @on 'sync', @resetNestedCollections, this
    
  resetNestedCollections: ->
    console.log "role #{@cid} resetting nested collections"
    
    #@entities = new DssRm.Collections.Entities(@get('entities')) if @entities is `undefined`
    @assignments = new Backbone.Collection if @assignments is `undefined`
    
    _.each @get('assignments'), (a) =>
      if a._destroy
        debugger
    
    # Reset nested collection data
    #@entities.reset @get('entities')
    @assignments.reset @get('assignments')
    
    console.log "role #{@cid} now has #{@assignments.length} assignments"
    
    if @get('assignments')
      if @assignments.length != @get('assignments').length
        debugger
    
    # Enforce the design pattern by removing from @attributes what is represented in a nested collection
    #delete @attributes.entities
    delete @attributes.assignments
  
  tokenize: (str) ->
    String(str).replace(RegExp(" ", "g"), "-").replace(/'/g, "").replace(/"/g, "").toLowerCase()
  
  # Returns true if the entity is assigned to this role
  # Accepts an entity or an entity_id
  # If 'include_calcualted' is false, has_assigned will not return
  # an entity which is technically assigned to this role if it is via
  # a calculated assignment.
  has_assigned: (entity, include_calculated = true) ->
    if entity.get == undefined
      # Looks like 'entity' is an ID
      id = entity
    else
      # Looks like 'entity' is a model
      id = (entity.get('group_id') || entity.id)
    
    # Use 'filter' as the entity_id may appear in multiple assignments
    results = @assignments.filter (a) =>
      (a.get('entity_id') == id) && ((a.get('calculated') == false) or include_calculated)
    
    return results.length
  
  toJSON: ->
    json = {}
    
    console.log "toJSON called (probably a save) for role #{@cid}, assignments.length = #{@assignments.length}"

    json.name = @get('name')
    json.token = @get('token')
    json.description = @get('description')
    json.ad_path = @get('ad_path')

    # Note we use Rails' nested attributes here
    if @assignments.length
      json.role_assignments_attributes = @assignments.map (assignment) =>
        id: assignment.get('id')
        entity_id: assignment.get('entity_id')
        role_id: @get('id')
        _destroy: assignment.get('_destroy')
    
    role: json
)

DssRm.Collections.Roles = Backbone.Collection.extend(
  model: DssRm.Models.Role
  url: "/roles"
)
