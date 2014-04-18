#!/usr/bin/env lsc
require! <[optimist async]>
require! \./lib/cli

data = require require.resolve \./output/person.json
plx <- cli.plx {+client}
update-entries = (data, record_info, next) ->
  funcs = for let entry in data
    f = (done) ->
      console.log "Inserting #{record_info entry}"
      memberships = entry.memberships
      delete entry.memberships
      <- plx.query "select pgrest_insert($1)",
        [collection: \person, $: entry]
      [pgrest_select:res] <- plx.query "select pgrest_select($1)",
        [collection: \person, q: {name:entry.name}, fo:true]
      _update = ->
        it.person_id = res.id
        it
      _memberships = [_update e for e in memberships]
      <- plx.query "select pgrest_insert($1)",
         [collection: \memberships, $: _memberships]
      done!
  err, res <- async.series funcs
  next!

<- update-entries data, -> it.name
console.log "inserted persons entries from orglist to postgresql."
plx.end!
