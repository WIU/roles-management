DssRm.Views.ApplicationsIndex = Backbone.View.extend(
  tagName: "div"
  id: "applications"
  className: "row"
  
  initialize: (options) ->
    @$el.html JST["templates/applications/index"]()
    
    @cards = new DssRm.Views.ApplicationsIndexCards()
    @sidebar = new DssRm.Views.ApplicationsIndexSidebar()
    
    states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
      'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii',
      'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
      'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
      'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
      'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
      'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
      'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
      'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
    ]
    
    # constructs the suggestion engine
    states = new Bloodhound
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      # `states` is an array of state names defined in "The Basics"
      local: $.map(states, (state) -> { value: state })
 
    # kicks off the loading/processing of `local` and `prefetch`
    states.initialize()
 
    debugger
    
    @$('.unified-search-bar .typeahead').typeahead
      hint: true,
      highlight: true,
      minLength: 1
    ,
      name: 'states',
      displayKey: 'value',
      # `ttAdapter` wraps the suggestion engine in an adapter that
      # is compatible with the typeahead jQuery plugin
      source: states.ttAdapter()
  
  render: ->
    @$('#cards-area').replaceWith @cards.render().el
    @$('#sidebar-area').replaceWith @sidebar.render().el
    @
)
