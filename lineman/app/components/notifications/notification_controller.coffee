angular.module('loomioApp').controller 'NotificationController', ($scope, LmoUrlService, Records) ->
  console.log $scope.notification.eventId
  console.log Records.events.find($scope.notification.eventId)
  console.log 'hi'

  $scope.event = $scope.notification.event()
  $scope.actor = $scope.event.actor()

  $scope.link = ->

    switch $scope.event.kind
      when 'comment_liked' then LmoUrlService.comment($scope.event.comment())
      when 'motion_closing_soon' then LmoUrlService.motion($scope.event.proposal())


  return
