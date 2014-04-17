#!/usr/bin/env lsc
require! <[optimist async]>
require! \./lib/cli

data = require require.resolve \./output/organization.json
plx <- cli.plx {+client}
update-entries = (data, record_info, next) ->
  funcs = for let entry in data
    f = (done) ->
      console.log "Inserting #{record_info entry}"
      <- plx.query "select pgrest_insert($1)", 
        [collection: \organizations, $: entry <<< parent_id: 0]
      done!
  err, res <- async.series funcs
  next!

<- update-entries data, -> it.name
console.log "inserted organizations entries from orglist to postgresql."
plx.end!