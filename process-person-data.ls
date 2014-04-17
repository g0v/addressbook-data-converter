require! <[async fs]>
utils = require './lib/utils'
require! \./lib/cli

index = require \./data-index.json
orgids = {}
plx <- cli.plx {+client}
res <- plx.query "select id, name from organizations;"
for v in res
  orgids[v.name] = v.id
acc = {data:[], count:0, orgids: orgids}
funcs = []
for let set in index.person
  funcs.push (done) ->
    processor = utils.guess-processor 'person', set
    if processor
      console.log "processing #{set.name}..."
      next_acc <- processor acc, set.output-file
      acc = next_acc
      done!
    else
      console.log "skip processing #{set.name}..."
      done!

err, res <- async.series funcs
console.log "processed #{acc.count} items."
product_path = 'output/person.json'
err <- fs.writeFile product_path, JSON.stringify [v for _,v of acc.data], null, 4
if err then throw err
console.log "produced file: #{product_path}."
plx.end!
