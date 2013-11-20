RolesManagement.controller "RoleAssignmentsCtrl", @RoleAssignmentsCtrl = ($scope, $http) ->
  # Load all role assignments
  
  $scope.assignments = []
  $scope.roles = []
  $scope.groups = []
  $scope.people = []
  $scope.applications = []
  
  $http(
    method: "GET"
    url: "/role_assignments.json"
  ).success((assignments, status, headers, config) =>
    # Parse assignment data
    roles = []
    applications = []
    groups = []
    people = []
    peopleGroups = []

    _.each assignments, (assignment) =>
      assignments.push { id: assignment.id, entity_id: assignment.entity.id, role_id: assignment.role.id, parent_id: assignment.parent_id }
      roles.push { id: assignment.role.id, name: assignment.role.name, application_id: assignment.application.id }
      applications.push { id: assignment.application.id, name: assignment.application.name }
      if assignment.entity.type == 'Group'
        groups.push { id: assignment.entity.id, name: assignment.entity.name }
      else
        people.push { id: assignment.entity.id, name: assignment.entity.name }
    
    $scope.assignments = _.uniq(assignments, false, (i) -> i.id )
    $scope.roles = _.uniq(roles, false, (i) -> i.id )
    $scope.groups = _.uniq(groups, false, (i) -> i.id )
    $scope.people = _.uniq(people, false, (i) -> i.id )
    $scope.applications = _.uniq(applications, false, (i) -> i.id )
    $scope.peopleGroups = []
    
    $scope.people = _.sortBy($scope.people, (person) -> person.name)
    
    $scope.peopleGroups = sliceWithLabels($scope.people, 5)
    
  ).error (data, status, headers, config) =>
    console.log 'Unable to load role assignments data!'
  
  sliceWithLabels = (array, chunkSize) =>
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
