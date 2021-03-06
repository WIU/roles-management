DssRm.Views.SidebarPin = Backbone.View.extend(
  tagName: "li"
  events:
    "click a.entity-favorite-link" : "toggleEntityFavorite"
    "click"                        : "pinClicked"

  initialize: (options) ->
    @listenTo @model, "change", @render
    @listenTo DssRm.view_state, "change", @render

    @$el.html JST["templates/entities/item"](entity: @model)
    @$el.addClass (@model.get('type') || 'group').toLowerCase()
    
    @highlighted = options.highlighted
    @faded = options.faded

  render: ->
    @$("span").html @model.escape('name')
    
    # Highlight this entity?
    if @highlighted
      @$el.addClass "highlighted"
    
    # Change actionable icons depending on ownership
    # if !@assignedToCurrentUser()
    #   @$("i.icon-minus").hide()
    
    # Is this pin unrelated to the current_user? Make it appear faded
    if @faded
      @$el.addClass "faded"
    
    # Is this entity a favorite?
    if @favoritedByCurrentUser()
      @$('a.entity-favorite-link>i').addClass('icon-star').removeClass('icon-star-empty').attr('title', 'Unfavorite')
    else
      @$('a.entity-favorite-link>i').removeClass('icon-star').addClass('icon-star-empty').attr('title', 'Favorite')
    
    # if @model.isReadOnly()
    #   @$("i.icon-remove").hide()
    #   @$("i.icon-search").hide()
    # else
    @$("i.icon-lock").hide()
    @$(".entity-details-link").attr("href", @entityUrl()).on "click", (e) ->
      e.stopPropagation() # stop parent from receiving click
    
    @

  entityUrl: ->
    unless @model.get('entity_id')
      debugger
    "#" + "/entities/" + @model.get('entity_id')

  toggleEntityFavorite: (e) ->
    e.stopPropagation()
    
    model_id = (@model.get('group_id') || @model.get('entity_id'))
    favorites_entity = DssRm.current_user.favorites.find((e) ->
      e.id is model_id
    )
    
    if favorites_entity
      # Unfavoriting
      DssRm.current_user.favorites.remove favorites_entity
    else
      # Favoriting
      DssRm.current_user.favorites.add
        id: @model.get('entity_id')
        entity_id: @model.get('entity_id')
        type: @model.get('type')
        name: @model.get('name')
    
    DssRm.current_user.save()
  
  # True if in current_user's favorites, group ownerships, or group operatorships
  assignedToCurrentUser: ->
    return DssRm.view_state.bookmarks.find (i) =>
      return i.get('id') is @model.get('id')
  
  # Returns true if this entity is favorited by the current user
  favoritedByCurrentUser: ->
    return DssRm.current_user.favorites.find (f) =>
      return f.get('id') is @model.get('entity_id')
  
  pinClicked: (e) ->
    e.stopPropagation()
    
    # Mobile browsers don't support hover, so, if the hover controls haven't appeared
    # by now (as they will on desktop browsers via CSS hover), we'll simply display
    # those hover controls and return. If they 'click' (touch) again, we'll proceed
    # as normal
    if @$('i:first').css('display') == 'none'
      @$('i').css('display', 'block')
      return
    
    # do nothing if this pin is faded
    return if @faded
    
    id = @model.get('entity_id')
    
    # If a role is selected, toggle the entity's association with that role.
    # If no role is selected, merely filter the application/role list to display their assignments. (not implemented yet)
    selected_role = DssRm.view_state.getSelectedRole()

    if selected_role
      # toggle on or off?
      matched = selected_role.assignments.filter((a) ->
        (a.get('entity_id') is id) and (a.get('calculated') == false)
      )
      
      if matched.length > 0
        # toggling off
        matched[0].set('_destroy', true)
        
        selected_role.save()
      else
        # toggling on
        new_entity = new DssRm.Models.Entity(id: id)
        new_entity.fetch success: =>
          selected_role.assignments.add
            entity_id: new_entity.id
            calculated: false
          selected_role.save()
)
