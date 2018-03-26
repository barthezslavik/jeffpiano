angular.module('app.clientApp').controller("ClientCtrl", [
  '$scope',
  ($scope)->
    console.log 'ClientCtrl running'
    $scope.exampleValue = "Hello angular and rails"
  ])

