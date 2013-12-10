RolesManagement.Models.Group = Backbone.Model.extend()

RolesManagement.Collections.Groups = Backbone.Collection.extend
  model: RolesManagement.Models.Group
  url: "/groups"

  findByOuId: (id) ->
    @filter (group) =>
      group.get('ou_id') == id
