#!/usr/bin/env lsc
require! <[optimist async fs]>
require! \./lib/cli

data = require require.resolve \./output/organization.json
parent_maps = {}
plx <- cli.plx {+client}
update-entries = (data, record_info, next) ->
  funcs = for let entry in data
    f = (done) ->
      console.log "Inserting #{record_info entry}"
      if entry.parent_id
        parent_maps[entry.name] = entry.parent_id
      <- plx.query "select pgrest_insert($1)",
        [collection: \organizations, $: entry <<< parent_id: 0]
      done!
  err, res <- async.series funcs
  next!

<- update-entries data, -> it.name
console.log "inserted organizations entries from orglist to postgresql."
product_path = 'output/organization_rel.json'
err <- fs.writeFile product_path, JSON.stringify parent_maps, null, 4
if err then throw err
console.log "produced file: #{product_path}."
plx.end!
