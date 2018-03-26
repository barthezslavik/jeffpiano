app = angular.module('app.clientApp')

app.directive 'shortcut', ->
  {
    restrict: 'E'
    replace: true
    scope: true
    link: (scope, iElement, iAttrs) ->
      jQuery(document).on 'keyup', (e) ->
        scope.$apply scope.keyUp(e)
        return
      return
  }

app.controller('ClientCtrl', ['$scope',
  ($scope)->
    $scope.onAir = false
    $scope.recBtnText = 'REC'
    $scope.source = 'videos/1.mp4'
    $scope.video = document.getElementById('video')

    $scope.keyUp = (e) ->
      if (e.target.tagName == 'INPUT')
        return
      key = String.fromCharCode(e.keyCode)
      if (key == '1' || key == '2' || key == '3')
        d = new Date()
        $scope.source = "videos/#{key}.mp4"
        setTimeout(play, 0)
        return

    play = ->
      $scope.video.play()

    $scope.recording = ->
      if ($scope.onAir)
        $scope.recBtnText = 'REC'
      else
        $scope.recBtnText = 'STOP'
      $scope.onAir = !$scope.onAir

    $scope.playVideo = (number)->
      $scope.source = "videos/#{number}.mp4"
      $scope.video.play()

  ])

