require! <[cheerio request async url mkdirp fs path]>

fetch-gov-data = (category, set, done) ->
  err, res, body <- request set.url
  throw \err if err
  [name, uri] = parse-set-datagov body
  nodeid = path.basename (url.parse set.url).path

  if set.real_url?
    uri = set.real_url

  if set.output_file?
    fname = set.output_file 
  else
    ext = path.extname uri .toLowerCase!
    rfname = "data-gov-node-#{nodeid}-source#{ext}"
    fname = "rawdata/#{category}/#{rfname}"

  _, {size}? <- fs.stat fname
  return done! if size?

  console.log "download #name to #{fname} ..."
  writer = with fs.createWriteStream fname
    ..on \error -> throw it
    ..on \close -> 
      <- setTimeout _, 1000ms
      console.log \done fname
      done!
  console.log uri
  request {method: \GET, uri} .pipe writer

export function grab-data(index , done)
  funcs = []
  for category, sets of index =>
    console.log "=> fetching #category"
    funcs.push (done) ->
      err <- mkdirp "rawdata/#{category}"
      throw err if err
      done!

    for let set in sets
      funcs.push (done) ->
        <- fetch-gov-data category, set
        done!
  err, res <- async.waterfall funcs
  done!

export function parse-set-datagov(cnt)
  $ = cheerio.load cnt
  name = $ 'h1[class="title"]' .text!
  uri = $ '#node_metadataset_full_group_data_type' 
    .find 'div .field-item' 
    .find \a 
    .attr \href
  [name, uri]