RolesManagement.Models.Role = Backbone.Model.extend(
)

RolesManagement.Collections.Roles = Backbone.Collection.extend(
  model: RolesManagement.Models.Role
  url: "/roles"

  findByApplicationId: (id) ->
    console.log 'find by application id'
    console.log id
    console.log @, 'roles collection'
    
    @filter (role) =>
      role.get('application_id') == id
)
