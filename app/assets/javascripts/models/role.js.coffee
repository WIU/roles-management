RolesManagement.Models.Role = Backbone.Model.extend()

RolesManagement.Collections.Roles = Backbone.Collection.extend
  model: RolesManagement.Models.Role
  url: "/roles"

  findByApplicationId: (id) ->
    @filter (role) =>
      role.get('application_id') == id
