require! time

export function parse_roc_date(d)
  [_, y, m, d] = d.match /^(\d\d\d?)(\d\d)(\d\d)/
  [+y + 1911, +m , +d]

export function date_from_rocdate(d)
  return null unless d
  [y, m, d] = parse_roc_date d
  new time.Date y, m, d, 'Asia/Taipei' .toString!