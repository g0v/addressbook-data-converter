require! <[cheerio request async url mkdirp fs path]>

save-remote = (uri, fname, done) ->
  _, {size}? <- fs.stat fname
  return done! if size?

  writer = with fs.createWriteStream fname
    ..on \error -> throw it
    ..on \close ->
      <- setTimeout _, 1000ms
      console.log \done fname
      done!
  console.log uri
  request {method: \GET, uri} .pipe writer

fetch-gov-data = (category, set, done) ->
  err, res, body <- request set.url
  throw \err if err
  [name, uri, ext] = parse-set-datagov body
  nodeid = path.basename (url.parse set.url).path

  if set.real_url?
    uri = set.real_url

  if set.output_file?
    fname = set.output_file
  else
    rfname = "data-gov-node-#{nodeid}-source.#{ext}"
    fname = "rawdata/#{category}/#{rfname}"
  console.log "download #name to #{fname} ..."
  save-remote uri, fname, done

fetch-github-data = (category, set, done) ->
  uri = set.url
  _p = (url.parse set.url .path / \/)
  project = "#{_p.1}-#{_p.2}"
  rfname = path.basename set.url
  fname = "rawdata/#{category}/github-#{project}-#{rfname}"
  console.log "download github rawdata to #{fname}"
  save-remote uri, fname, done

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
        match set.url
        | /data.gov.tw/ =>
          <- fetch-gov-data category, set
        | /githubusercontent/ =>
          <- fetch-github-data category, set
        | otherwise => console.log "can not find fecther of #{set.url}."
        done!
  err, res <- async.waterfall funcs
  done!

export function parse-set-datagov(cnt)
  $ = cheerio.load cnt
  name = $ 'h1[class="title"]' .text!
  e = $ '#node_metadataset_full_group_data_type'
    .find 'div .field-item'
    .find \a
  uri = e.attr \href
  ext = match e.attr \class
        | /json/ => \json
        | /csv/ => \csv
        | /xml/ => \xml
        | _ => throw 'can not find extension.'
  [name, uri, ext]
