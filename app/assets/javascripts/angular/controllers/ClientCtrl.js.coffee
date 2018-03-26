app = angular.module('app.clientApp')

app.directive 'shortcut', ->
  {
    restrict: 'E'
    replace: true
    scope: true
    link: (scope, iElement, iAttrs) ->
      jQuery(document).on 'keypress', (e) ->
        scope.$apply scope.keyPressed(e)
        return
      return
  }

app.controller('ClientCtrl', ['$scope',
  ($scope)->
    $scope.onAir = false
    $scope.recBtnText = 'REC'
    $scope.source = 'videos/1.mp4'

    $scope.keyPressed = (e) ->
      key = String.fromCharCode(e.keyCode)
      if (key == '1' || key == '2' || key == '3')
        $scope.source = "videos/#{key}.mp4"

    $scope.recording = ->
      if ($scope.onAir)
        $scope.onAir = false
        $scope.recBtnText = 'REC'
      else
        $scope.onAir = true
        $scope.recBtnText = 'STOP'

    $scope.playVideo = (number)->
      $scope.src = 'videos/' + number + '.mp4'

  ])

