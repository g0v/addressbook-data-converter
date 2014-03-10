grab-data = (require \./lib) .crawer! .grab-data

load-index = (path, done) ->
  data-index = require path
  for catgory, v of data-index
    throw "err" unless v.length
    console.log "#catgory data sets: #{v.length}"
  done data-index

# main 
index <- load-index \./data-index.json
err <- grab-data index 
if err then console.log err else console.log \done!