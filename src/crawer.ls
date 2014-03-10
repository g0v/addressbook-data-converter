require! <[cheerio request async]>

fetch-gov-data = (set, done) ->
  err, res, body <- request set.url
  throw \err if err
  [name, url] = parse-set-datagov body
  if set.real_url?
    url = set.real_url
  console.log "download #name from #url ..."
  done!

export function grab-data(index , done)
  funcs = []
  for catgory, sets of index =>
    console.log "=> fetching #catgory"
    for let set in sets
      funcs.push (done) ->
        <- fetch-gov-data set
        done!
  err, res <- async.waterfall funcs
  done!

export function parse-set-datagov(cnt)
  $ = cheerio.load cnt
  name = $ 'h1[class="title"]' .text!
  url = $ '#node_metadataset_full_group_data_type' 
    .find 'div .field-item' 
    .find \a 
    .attr \href
  [name, url]