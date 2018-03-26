app = angular.module('app.clientApp')

app.controller('ClientCtrl', ['$scope',
  ($scope)->
    $scope.onAir = false
    $scope.recBtnText = 'REC'
    $scope.src = 'videos/1.mp4'

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

