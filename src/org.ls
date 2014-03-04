require! fs
require! csv

# Orgnization
ensured_record = (record) ->
  throw 'name is empty' unless record.name
  throw 'orgcode is empty' unless record.orgcode
  record

popololized_orglist_record = (record) ->
  #@FIXME: workround.
  if record.orgcode == '機關代碼' 
    return null
  record = ensured_record record

  find_other_names = ->
      ret = []
      if record.dissolution_note is \是
        ret.push do
          name: record.name
          start_date: null
          end_date: record.dissolution_date
      else if record.dissolution_note is not \是 and record.old_name?
        ret.push do
          name: record.old_name
          start_date: null
          end_date: null
      ret
  find_current = -> 
    other_names = []
    if record.dissolution_note is \是 and record.new_name
      [record.new_name, find_other_names!, record.new_orgcode, record.dissolution_date, null]
    else
      [record.name, find_other_names!, record.orgcode, null, null]

  [name, other_names, orgcode, founding_date, dissolution_date] = find_current!
  throw name unless name
  # make a new record. 
  do
    name: name
    other_names: other_names
    identifiers: [
        * identifier: orgcode
          scheme: \orgcode
    ]
    classification: record.classification
    parent_id: record.parent_orgcode
    founding_date: founding_date
    dissolution_date: dissolution_date
    image: null
    contact_details: [
        * label: \機關電話
          type: \voice
          value: record.phone
          source: null
        * label: \機關傳真
          type: \fax
          value: record.fax
          source: null
    ]
    links: []

# CSV -> Array
export function from_orglist(path, done)
  opts = do
    columns: do
      orgcode: \機關代碼
      name: \機關名稱
      zipcode: \郵遞區號
      address: \機關地址 
      phone: \機關電話
      parent_orgcode: \主管機關代碼
      parent_name: \主管機關名稱
      fax: \傳真
      start_date: \機關生效日期
      dissolution_date: \機關裁撤日期
      classification: \機關層級
      dissolution_note: \裁撤註記
      new_orgcode: \新機關代碼
      new_name: \新機關名稱
      new_start_date: \新機關生效日
      old_orgcode: \舊機關代碼
      old_name: \舊機關名稱
  from_csv path, opts, popololized_orglist_record, done

export function convert_orglist(path, dest, done) 
  result, count <- from_orglist path
  json = JSON.stringify result, null, 4
  err <- fs.writeFile dest, json
  done err, count

export function from_csv(path, opts, transform_cb, done)
  csv!
    .from path, opts
    .transform (record, index, callback) ->
      process.nextTick -> callback null, transform_cb record
    .on \error, -> console.log it.message
    .to.array done 