#!/usr/bin/env lsc
require! <[request async fs url path]>
{parse-set-prop-twgovdata} = require \./lib/crawer
cfg = require \./config.json
data-index = {}
funcs = []
for category, sets of cfg.sources
  data-index[category] = [] unless data-index.category?
  for let set in sets
    funcs.push (done) ->
      parsed_url = (url.parse set.url)
      _p = path.basename set.url
      set.ext = path.extname (_p) .replace '.', ''
      set.id = _p.replace ".#{set.ext}", ''
      set.category = category
      if parsed_url.protocol == 'file:'
        set.uri = set.url
        set.output-file = set.url.replace "file://", ''
        set.provider = 'native'
        data-index[category].push set
        done!
      else if parsed_url.protocol in ['http:', 'https:']
        match set.url
        | /data.gov.tw/ =>
          provider_name = 'twgovdata'
          err, res, body <- request set.url
          throw "err" if err
          set <<< parse-set-prop-twgovdata body
          set.provider = "#{parsed_url.protocol}//#{parsed_url.host}"
          set.output-file = "rawdata/#{category}/source-#{provider_name}-#{set.id}.#{set.ext}"
          data-index[category].push set
          done!
        | /github/ =>
          provider_name = 'github'
          set.provider = "#{parsed_url.protocol}//#{parsed_url.host}"
          set.uri = set.url
          set.output-file = "rawdata/#{category}/source-#{provider_name}-#{set.id}.#{set.ext}"
          data-index[category].push set
          done!
        | _ => throw "unsupported provider"
      else
        throw "#{set.name}: unsupported protocol"
console.log "starting update data-index.json..."
err, res <- async.waterfall funcs
err <- fs.writeFile \data-index.json, JSON.stringify data-index, null, 4
console.log "updateed data-index.json."
