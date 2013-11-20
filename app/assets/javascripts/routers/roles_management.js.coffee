rolesManagementRouter = ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "/assets/partials/role_assignments.html"
    controller: "RoleAssignmentsCtrl"
  )

includeCSRF = ($httpProvider) ->
  $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")

window.RolesManagement = angular.module("roles-management", ["ngRoute"])

RolesManagement.config rolesManagementRouter
RolesManagement.config includeCSRF

console.log 'here at bottom of router'
