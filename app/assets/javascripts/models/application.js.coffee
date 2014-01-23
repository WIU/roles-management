RolesManagement.Models.Application = Backbone.Model.extend()

RolesManagement.Collections.Applications = Backbone.Collection.extend
  model: RolesManagement.Models.Application
  url: "/applications"
