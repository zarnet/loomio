angular.module('loomioApp').factory 'LmoUrlService', ->
  new class LmoUrlService
    stub: (name) ->
      name.replace(/[^a-z0-9\-_]+/gi, '-').toLowerCase()

    discussion: (d) ->
      "/d/"+d.key+"/"+@stub(d.title)

    comment: (c) ->
      d = c.discussion()
      "/d/"+d.key+"/"+@stub(d.title)+"#commment-#{c.id}"
