# # Data Fetching

# ## Data Sources Configure
#
# The fecther fetches rawdata from the remote sites which are defined
# in `data-index.json`, which is automatically preoduced in `npm run prepublish`
# step. You should modify `config.ls` instead of modifying `data-index.json`.

# `data-index.ls` Syntax:
# ```
# Category: [Set]
# ```
# * Cateogry: String, the category that sets belong to.
# * Set: Object, the rawdata name, resource uri, etc.

# ## Set Properties
# A remote site which provides rawdata should provide necessary
# information that a crawler can know how to find real uri of the
# rawdata, how often a crawler should re-fetch the data, etc.
#
# ### Porpertie Definitions
# - name: rawdata name.
# - id: unique identifier used by provider.
# - provider: data provider.
# - url: set profile url that displays propoerties.
# - ext: file extension. valid: (csv, xml, json)
# - uri: real uri of the rawdata.
# - update-freq: update frequency.
require! <[cheerio request async url mkdirp fs path]>

save-remote = (name, uri, fname, done) ->
  _, {size}? <- fs.stat fname
  return done! if size?

  writer = with fs.createWriteStream fname
    ..on \error -> throw it
    ..on \close ->
      <- setTimeout _, 1000ms
      console.log "finished downloading #{name}: save file: #{fname}"
      done!
  console.log "starting download #{name} ..."
  request {method: \GET, uri} .pipe writer

export function grab-data(index , done)
  funcs = []
  for let category, sets of index =>
    console.log "=> fetching #category"
    funcs.push (done) ->
      err <- mkdirp "rawdata/#{category}"
      throw err if err
      done!

    for let set in sets
      funcs.push (done) ->
        <- save-remote set.name, set.uri, set.output-file
        done!
  err, res <- async.waterfall funcs
  done!

export function parse-set-prop-twgovdata(html)
  lookup-prop = (tbl, n) ->
    trs = tbl.find 'tr' .nextAll!
    try
      e = trs[n]
        .children
        .0
        .next
        .children
        .0 .children
        .0 .children
        .0 .children
        .0
      e.data
    #@FIXME: update frequncy parsing can not handle all cases.
    catch error
      return "不定期"

  prop = do
    name: null
    uri: null
    ext: null
    update-freq: null

  $ = cheerio.load html
  prop.name = $ 'h1[class="title"]' .text!
  e = $ '#node_metadataset_full_group_data_type'
    .find 'div .field-item'
    .find \a
  prop.uri = e.attr \href
  prop.ext = match e.attr \class
        | /json/ => \json
        | /csv/ => \csv
        | /xml/ => \xml
        | _ => throw 'can not find extension. dbg: #it'
  prop_tbl = $ 'table[class="field-group-format group_table"]'
  prop.update-freq = lookup-prop prop_tbl, 5
  for k,v of prop
    throw "prop #{k} is empty." unless v
  return prop
