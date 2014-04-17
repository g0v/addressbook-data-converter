#!/usr/bin/env lsc
require! <[fs]>
require! \./lib/cli

data = require require.resolve \./output/organization.json
plx <- cli.plx {+client}
res <- plx.query "select id, name from organizations;"
_m = {}
for e in res
  _m[e.name] = e.id
err <- fs.writeFile 'org-ids.json', JSON.stringify _m, null, 4
if err then throw err
console.log 'update org-ids.json.'
plx.end!