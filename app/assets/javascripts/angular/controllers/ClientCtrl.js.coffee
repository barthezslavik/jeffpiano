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
        $scope.playVideo(key)

    $scope.save = ->
      $scope.canSave = false
      $http.post('records.json', {
        name: $scope.name,
        chunks_attributes: $scope.chunks
          }).then (res) ->
            getRecordsList()
            $scope.name = ''

    $scope.processDom = (source) ->
      # add chunk state as element class
      $('.finished').remove()
      $('.playing').hide()
      parent = document.getElementById('parent')
      player = document.createElement('video')
      player.setAttribute('class', 'playing')
      player.style.width = '640px'
      player.style.height = '360px'
      player.onended = ->
        # hide DOM when finished
        player.setAttribute('class', 'finished')
        if $('.playing').length > 0
          $('.playing').last().show()
          player.remove()
        return
      parent.appendChild(player)
      play(player, source)

    $scope.processChunk = (source) ->
      start_at = Date.now() - $scope.startRecordTime
      $scope.chunks.push({
        start_at: start_at,
        source: source
      })

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
        $('video').get(0).pause()

    $scope.playVideo = (number)->
      source = "videos/#{number}.mp4"
      $scope.processChunk(source)
      $scope.processDom(source)

    $scope.playRecord = (id)->
      $http.get("records/#{id}.json").then (res) ->
        $scope.chunks = res.data['chunks']
        $scope.chunks.forEach (chunk, i, chunks) ->
          setTimeout(->
            # pause video if record ended
            if (chunk.source == null)
              $('video').show()
              $('video').get(0).pause()
            else
              $scope.processDom(chunk.source)
            # align first chunk with zero
          , chunk.start_at - chunks[0].start_at)

    play = (player, source) ->
      player.setAttribute('src', source)
      player.load()
      player.play()
  ])
