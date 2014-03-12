#!/usr/bin/env lsc
require! <[optimist async fscache]>
require! \./lib/cli

{input, db} = optimist.argv

orglist = require require.resolve input

_orgcode_map = {}
for e in orglist
  if e.identifiers?
      _orgcode_map[e.identifiers.0.identifier] = e.name

plx <- cli.plx {+client}
update-entries = (data, record_info, next) ->
  funcs = for let entry in data
    (done) ->
      console.log "Inserting #{record_info entry}"
      res <- plx.query "select pgrest_insert($1)", [collection: \organizations, $: entry <<< parent_id: 0]
      done!
  err, res <- async.series funcs
  next!

#<- update-entries orglist, -> it.name
console.log "inserted organizations entries from orglist to postgresql."

missing-parents = []
update-parent-ids = (data, next) ->
  funcs = for let entry in data 
    (done) ->
      parent_name = _orgcode_map[entry.parent_id] 
      if parent_name?
        [pgrest_select:res] <- plx.query "select pgrest_select($1)", [collection: \organizations, q: {name: parent_name}]
        real_parent_id = res.entries.0.id
        res <- plx.upsert collection: \organizations  q: {name: entry.name}, $: $set: {parent_id: real_parent_id}, _, -> throw it
        console.log "Update parent id of #{entry.name} to #real_parent_id"
        done!
      else  
        missing-parents.push "#{entry.parent_id}" if entry.parent_id not in missing-parents
        done!
  err, res <- async.series funcs
  next!

<- update-parent-ids orglist
console.log "update all parent id."

console.log "missing parent\n"
console.log missing-parents

plx.end!
