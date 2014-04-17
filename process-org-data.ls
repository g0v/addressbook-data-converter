require! <[async fs]>
utils = require './lib/utils'
index = require \./data-index.json

taiwan-parties =
  * name: \中國國民黨
  * name: \民主進步黨
  * name: \台灣團結聯盟
  * name: \親民黨
  * name: \綠黨
  * name: \勞動黨
  * name: \新黨
missing-orgs =
  * name: \臺南市議會
  * name: \臺北市議會
  * name: \臺中市議會

new-acc = ->
  acc = {data:{}, count:0}
  for e in taiwan-parties
    acc.data[e.name] = e
    acc.count += 1
  return acc

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
