RolesManagement.Views.RoleAssignmentsPeopleColumn = Backbone.View.extend
  tagName: "div"
  id: "people"
  className: "col-md-4"
  
  initialize: (options) ->
    @$el.html JST["templates/role_assignments/people_column"]()

    # Set up "peopleGroups" (people sliced into groups based on names) for the view
    @peopleGroups = new Backbone.Collection() # stores RolesManagement.people sliced into labeled groups for the view
    @listenTo RolesManagement.people, 'reset', =>
      console.log 'rm people has reset itself:'
      console.log RolesManagement.people
      @peopleGroups.reset sliceWithLabels(RolesManagement.people)
    
    @listenTo @peopleGroups, 'reset', @render
  
  render: ->
    console.log @peopleGroups
    @
  
  sliceWithLabels = (array, chunkSize = 5) =>
    i = 0
    j = array.length
    slices = []
    
    last_label_stop = ""
    while i < j
      slice = array.slice(i, i + chunkSize)

      label_start = slice[0].name[0]
      if label_start == last_label_stop
        label_start = slice[0].name[0] + slice[0].name[1]
      
      label_stop = slice[slice.length - 1].name[0]
      
      label = label_start + '-' + label_stop
      if label_start == label_stop
        label = label_start
      
      slices.push { label: label, slice: slice }
      
      i += chunkSize
      last_label_stop = label_stop
    
    return slices
