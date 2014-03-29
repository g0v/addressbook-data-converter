require! <[fs cheerio]>
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
export function from_data_gov_7307(acc, path, done)
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

export function from_data_gov_6119(acc, path, done)
  orgmap = {}
  orgs = acc
  root = ''
  for org in orgs
    orgmap[org.name] = org
  opts = do
    columns: do
      area: \地區
      country: \國家名稱
      name_zh: \館處中文名稱
      name_en: \館處外文名稱
      offdate_id: '駐外館處休假日編號(系統用)'
      url: \網址
      address: '館址(外文)'
      zipcode: \信箱號碼
      phone: \電話
      ergency_call_zh: '緊急聯絡電話(中文)'
      ergency_call_en: '緊急聯絡電話(英文)'
      fax: \傳真
      supvisor_zh: '主管(中文)'
      supvisor_en: '主管(英文)'
      post: \職稱
      email: \EMAIL
      office_hour: \上班時間
      timezone: \時差
      manage_area_zh: '轄區(中文)'
      service_time: \領務服務時間
      post_unit: \所屬單位
      post_source: \消息來源

  _cb = (record) ->
    return null if record.area == '地區'
    if '(' in record.name_zh or '（' in record.name_zh
      [_, name_zh, name_en_zh] = record.name_zh.match /(.*)\s*[（(](.*)[)）]/
    else
      name_zh = record.name_zh

    o = do
      name: name_zh
      address: record.address
      other_names: [
        * name: record.name_en
          start_date:null
          end_date: null
      ]
      contact_details: [
        * label: '電話'
          type: 'voice'
          value: record.phone
        * label: '緊急聯絡電話'
          type: 'voice'
          value: record.ergency_call_zh
        * label: '電子郵件'
          type: 'email'
          value: record.email
        * label: '傳真'
          type: 'fax'
          value: record.fax
      ]
      parent_id: null

    if name_zh in orgmap
      orgmap[name_zh] <<< o
    else
      orgmap[o.name] = o
    o
  <- util.from_csv path, opts, _cb
  result = [e for _, e of orgmap]
  done result, result.length

export function from_data_gov_7437(acc, path, done)
  correct_name = ->
    badnames =
      \高雄市那瑪夏區
      \高雄市桃源區
      \高雄市甲仙區
      \高雄市旗山區
      \花蓮縣秀林鄉
      \花蓮縣瑞穗鄉
      \花蓮縣光復鄉
      \花蓮縣玉里鎮
      \桃園縣楊梅市
      \金門縣烏坵鄉
      \金門縣烈嶼鄉
      \金門縣金寧鄉
      \金門縣金沙鎮
    if it in badnames then "#{it}戶政事務所" else it

  orgmap = {}
  orgs = acc

  for org in orgs
    orgmap[org.name] = org

  content = fs.readFileSync path, 'utf-8'
  content = content.replace /orgName/g, 'orgname'
  $ = cheerio.load content, {xmlMode:true}
  orgs = $ 'orgs' .find 'org'

  get = (o, q) -> o.find q .text!
  orgs.each ->
    obj = do
      name: correct_name (get @, 'orgname')
      address: get @, 'address'
      other_names: []
      contact_details: [
        {label: '機關電話', 'type': 'voice', 'value': get @, 'tel'}
        {label: '機關電郵', 'type': 'email', 'value': get @, 'email'}
        {label: '機關傳真', 'type': 'fax', 'value': get @, 'fax'}
      ]
      note: get @, 'description'
      links: [
        * url: get @, 'website'
      ]
    unless orgmap[obj.name]
      orgmap[obj.name] = obj
    else
      orgmap[obj.name] <<< obj
  result = [e for _, e of orgmap]
  done result, result.length

export function from_data_gov_7620(acc, path, done)
  orgmap = {}
  orgs = acc

  for org in orgs
    orgmap[org.name] = org

  content = fs.readFileSync path, 'utf-8'
  $ = cheerio.load content, {xmlMode:true}
  orgs = $ 'channel' .find 'item'
  get = (o, q) -> o.find q .text!
  orgs.each ->
    [address, tel, email, fax] = [1,2,3,4]
    obj = do
      name: get @, 'title1'
      address: address
      other_names: []
      contact_details: [
        {label: '機關電話', 'type': 'voice', 'value': tel}
        {label: '機關電郵', 'type': 'email', 'value': email}
        {label: '機關傳真', 'type': 'fax', 'value': fax}
      ]
      note: get @, 'description'
      links: []
    unless orgmap[obj.name]
      orgmap[obj.name] = obj
    else
      orgmap[obj.name] <<< obj
  result = [e for _, e of orgmap]
  done result, result.length
