RolesManagement.Models.Entity = Backbone.Model.extend()

RolesManagement.Collections.Entities = Backbone.Collection.extend
  model: RolesManagement.Models.Entity
  url: "/entities"

  # findByOuId: (id) ->
  #   @filter (group) =>
  #     group.get('ou_id') == id
