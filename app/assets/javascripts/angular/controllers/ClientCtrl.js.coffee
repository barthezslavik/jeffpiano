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

app.controller('ClientCtrl', ['$scope', '$http',
  ($scope, $http)->
    $scope.onAir = false
    $scope.canSave = false
    $scope.recBtnText = 'REC'
    $scope.source = 'videos/1.mp4'
    $scope.video = document.getElementById('video')

    getRecordsList = ->
      $http.get('records.json').then (res) ->
        $scope.records = res.data
        return

    getRecordsList()

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

    $scope.save = ->
      $scope.canSave = false
      $http.post('records', {name: $scope.name}).then (res) ->
        getRecordsList()

    $scope.recording = ->
      $scope.onAir = !$scope.onAir
      if ($scope.onAir)
        $scope.canSave = false
        $scope.recBtnText = 'STOP'
      else
        $scope.canSave = true
        $scope.recBtnText = 'REC'

    $scope.playVideo = (number)->
      $scope.source = "videos/#{number}.mp4"
      $scope.video.play()

  ])

