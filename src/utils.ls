# # Utilities
require! time
require! csv
require! url
require! path

export function date(y, m, d)
  new time.Date y, m, d, 'Asia/Taipei' .toString!

export function parse_roc_date(d)
  [_, y, m, d] = d.match /^(\d\d\d?)(\d\d)(\d\d)/
  [+y + 1911, +m , +d]

export function date_from_rocdate(d)
  return null unless d
  [y, m, d] = parse_roc_date d
  new time.Date y, m, d, 'Asia/Taipei' .toString!

export function from_csv(path, opts, transform_cb, done)
  csv!
    .from path, opts
    .transform (record, index, callback) ->
      process.nextTick -> callback null, transform_cb record
    .on \error, -> console.log it.message
    .to.array done

export function guess-processor(category, set)
  basename = path.basename (url.parse set.url .path)
  modname = match category
    | /organization/ => \org
    | /person/ => \person
    | otherwise => throw "can not find module name."
  fnname = match set.url
    | /data.gov.tw/ => "process_twgovdata_#{basename}"
    | otherwise => throw "can not guess set name"
  try
    pkg = require "./#{modname}"
    throw "#modname is not a module." unless pkg?
    fn = pkg[fnname]
    throw "#fnname is not a function." unless typeof fn is \function
    fn
  catch
    return null
