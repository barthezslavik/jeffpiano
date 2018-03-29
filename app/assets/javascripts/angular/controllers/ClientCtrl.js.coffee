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
        source = "videos/#{key}.mp4"
        $scope.processChunk(source)

    $scope.save = ->
      $scope.canSave = false
      $http.post('records.json', {
        name: $scope.name,
        chunks_attributes: $scope.chunks
          }).then (res) ->
            getRecordsList()
            $scope.name = ''

    $scope.startRecording = ->
      $scope.onAir = !$scope.onAir
      if ($scope.onAir)
        $scope.chunks = []
        $scope.canSave = false
        $scope.recBtnText = 'STOP'
      else
        $scope.canSave = true
        $scope.recBtnText = 'REC'
        $scope.processChunk(null)

    $scope.playVideo = (number)->
      play("videos/#{number}.mp4")

    $scope.processChunk = (source) ->
      start_at = Date.now() - $scope.startRecordTime
      $scope.chunks.push({
        start_at: start_at,
        source: source
      })
      play(source)

    $scope.playRecord = (id)->
      $http.get("records/#{id}.json").then (res) ->
        $scope.chunks = res.data['chunks']
        $scope.chunks.forEach (chunk, i, chunks) ->
          setTimeout(->
            play(chunk.source)
            # align first chunk with zero
          , chunk.start_at - chunks[0].start_at)

    play = (src) ->
      if (src)
        $scope.video.pause()
        $scope.video.setAttribute('src', src)
        $scope.video.load()
        $scope.video.play()
      else
        $scope.video.pause()
  ])
