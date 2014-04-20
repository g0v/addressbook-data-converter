#!/usr/bin/env lsc
require! optimist
require! \./lib/cli
require! \./lib/org
{input} = optimist.argv

orgids = {}
plx <- cli.plx {+client}
res <- plx.query "select id, name from organizations;"
for v in res
  orgids[v.name] = v.id

data = require require.resolve "./#{input}"
o = []
used = []
for e in data
  orgname = org.normalized-name e.orgname
  unless orgids[orgname]?
    if orgname not in o
      o.push orgname
console.log JSON.stringify [{name:e} for e in o], null, 4
plx.end!
