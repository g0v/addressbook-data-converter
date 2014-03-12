require! time
require! csv

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