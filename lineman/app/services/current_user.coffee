angular.module('loomioApp').factory 'CurrentUser', (Records) ->
  currentUser = null
  if window? and window.Loomio?
    Records.import(window.Loomio.seedRecords)
    currentUser =  Records.users.find(window.Loomio.currentUserId)
    console.log 'currentUserId', window.Loomio.currentUserId, 'record', currentUser

  currentUser
