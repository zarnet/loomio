angular.module('loomioApp').directive 'notifications', ->
  scope: {}
  restrict: 'E'
  templateUrl: 'generated/components/notifications/notifications.html'
  replace: true
  controller: ($scope, UserAuthService, Records, CurrentUser) ->

    # todo
    # comment_replied_to
    #'membership_request_approved',
    kinds = [
      'comment_liked',
      'motion_closing_soon',
      #'comment_replied_to',
      'user_mentioned',
      'membership_requested',
      #'membership_request_approved',
      'user_added_to_group',
      'motion_closing_soon',
      'motion_outcome_created'
    ]

    Records.notifications.fetch()

    @notificationsView = Records.notifications.collection.addDynamicView("CurrentUser")
    @notificationsView.applySimpleSort('createdAt', true)
    @notificationsView.applyWhere (notification) ->
      _.contains(kinds, notification.event().kind)

    $scope.notifications = =>
      @notificationsView.data()

    return
