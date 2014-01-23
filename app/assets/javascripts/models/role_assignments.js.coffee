RolesManagement.Models.RoleAssignment = Backbone.Model.extend()

RolesManagement.Collections.RoleAssignments = Backbone.Collection.extend
  model: RolesManagement.Models.RoleAssignment
  url: "/role_assignments"
