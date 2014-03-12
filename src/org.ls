require! fs
require! \./util

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
      if record.dissolution_note is \是 and record.new_name?
        ret.push do
          name: record.new_name
          start_date: util.date_from_rocdate record.dissolution_date
          end_date: null
      else if record.dissolution_note is not \是 and record.old_name?
        ret.push do
          name: record.old_name
          start_date: null
          end_date: null
      ret

  do
    name: record.name
    other_names: find_other_names!
    identifiers: [
        * identifier: record.orgcode
          scheme: \orgcode
    ]
    classification: record.classification
    parent_id: record.parent_orgcode
    founding_date: util.date_from_rocdate record.founding_date
    dissolution_date: util.date_from_rocdate record.dissolution_date
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
  util.from_csv path, opts, popololized_orglist_record, done

export function convert_orglist(path, dest, done) 
  result, count <- from_orglist path
  json = JSON.stringify result, null, 4
  err <- fs.writeFile dest, json
  done err, count
