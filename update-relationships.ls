#!/usr/bin/env lsc
require! <[optimist async]>
require! \./lib/cli

code2id = {}
orgs = require \./output/organization_rel.json
funcs = []
plx <- cli.plx {+client}
res <- plx.query "select id, identifiers ~> '@.0.identifier' as orgcode from organizations"
for row in res
  code2id[row.orgcode] = row.id

nomeaning-orgcodes = []
for let orgname, parent_orgcode of orgs
  f = (done) ->
    parent_id = code2id[parent_orgcode]
    # found parent id in database.
    if parent_id
      console.log "updating parent_id to #{parent_id} of #{orgname}"
      <- plx.query "update organizations set parent_id=#{parent_id} where name='#{orgname}'"
      done!
    else
      if parent_orgcode not in nomeaning-orgcodes
        nomeaning-orgcodes.push parent_orgcode
      done!
  funcs.push f
<- async.series funcs
#console.log nomeaning-orgcodes
plx.end!
