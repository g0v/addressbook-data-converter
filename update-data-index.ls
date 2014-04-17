require! <[request async fs url path]>
{parse-set-prop-twgovdata} = require \./lib/crawer
cfg = require \./config.json
data-index = {}
funcs = []
for category, sets of cfg.sources
  data-index[category] = [] unless data-index.category?
  for let set in sets
    funcs.push (done) ->
      err, res, body <- request set.url
      throw "err" if err
      set <<< parse-set-prop-twgovdata body
      set.category = category
      parsed_url = (url.parse set.url)
      set.provider = "#{parsed_url.protocol}//#{parsed_url.host}"
      set.id = path.basename parsed_url.path
      set.output-file = "rawdata/#{category}/source-twgovdata-#{set.id}.#{set.ext}"
      data-index[category].push set
      done!
console.log "starting update data-index.json..."
err, res <- async.waterfall funcs
err <- fs.writeFile \data-index.json, JSON.stringify data-index, null, 4
console.log "updateed data-index.json."