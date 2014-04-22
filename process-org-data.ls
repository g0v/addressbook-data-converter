#!/usr/bin/env lsc
require! <[async fs]>
utils = require './lib/utils'
index = require \./data-index.json

new-acc = ->
  {data:{}, count:0}

acc = new-acc!
funcs = []
for let set in index.organization
  funcs.push (done) ->
    processor = utils.guess-processor 'organization', set
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
product_path = 'output/organization.json'
err <- fs.writeFile product_path, JSON.stringify [v for _,v of acc.data], null, 4
if err then throw err
console.log "produced file: #{product_path}."
