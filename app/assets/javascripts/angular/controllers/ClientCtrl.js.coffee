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
    $scope.video = document.getElementById('video')
    $scope.startRecordTime = Date.now()
    $scope.chunks = []

    getRecordsList = ->
      $http.get('records.json').then (res) ->
        $scope.records = res.data

    getRecordsList()

    $scope.keyUp = (e) ->
      if (e.target.tagName == 'INPUT')
        return
      key = String.fromCharCode(e.keyCode)
      if (key == '1' || key == '2' || key == '3')
        start_at = Date.now() - $scope.startRecordTime
        source = $scope.video.getAttribute('src')
        $scope.chunks.push({
          start_at: start_at,
          source: source
        })
        play("videos/#{key}.mp4")
        return

    $scope.save = ->
      $scope.canSave = false
      $http.post('records.json', {
        name: $scope.name,
        chunks_attributes: $scope.chunks
          }).then (res) ->
            getRecordsList()
            $scope.name = ''
            $scope.chunks = []

    $scope.recording = ->
      $scope.onAir = !$scope.onAir
      if ($scope.onAir)
        $scope.canSave = false
        $scope.recBtnText = 'STOP'
      else
        $scope.canSave = true
        $scope.recBtnText = 'REC'
        $scope.video.pause()

    $scope.playVideo = (number)->
      play("videos/#{number}.mp4")

    $scope.playRecord = (id)->
      $http.get("records/#{id}.json").then (res) ->
        $scope.current = res.data

    play = (src) ->
      $scope.video.pause()
      $scope.video.setAttribute('src', src)
      $scope.video.load()
      $scope.video.play()

    $scope.playCurrent = ->
      chunks = $scope.chunks
      $scope.chunks.forEach (chunk, i, arr) ->
        setTimeout(->
          play(chunk.source)
        , chunk.start_at)

  ])
