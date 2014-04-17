# # Organization Processor
require! <[fs cheerio]>
require! \./util

popololized-record-twgovdata_7307 = (acc, record) -->
  #@FIXME: workround.
  if record.orgcode == '機關代碼'
    return null
  find_other_names = ->
      ret = []
      if record.dissolution_note is \是 and record.new_name?
        ret.push do
          name: record.new_name
          start_date: util.date_from_rocdate record.dissolution_date
      else if record.dissolution_note is not \是 and record.old_name?
        ret.push do
          name: record.old_name
      ret

  acc.data[record.name] = do
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
        * label: \機關傳真
          type: \fax
          value: record.fax
    ]
    links: []
    sources:
      * url: 'http://data.gov.tw/node/7307'
  acc.count += 1

export function process_twgovdata_7307(acc, src, done)
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
  _, count <- util.from_csv src, opts, popololized-record-twgovdata_7307 acc
  done acc

popololized-record-twgovdata_6119 = (acc, record) -->
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
  if acc.data[name_zh]?
    acc.data[name_zh] <<< o
  else
    acc.data[o.name] = o
  acc.count += 1
  o

export function process_twgovdata_6119(acc, src, done)
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
  _, count <- util.from_csv src, opts, popololized-record-twgovdata_6119 acc
  done acc

export function process_twgovdata_7437(acc, path, done)
  correct_name = ->
    return '內政部戶政司' if it is \內政部戶政司戶政司
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

  content = fs.readFileSync path, 'utf-8'
  content = content.replace /orgName/g, 'orgname'
  $ = cheerio.load content, {+xmlMode}
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
    unless acc.data[obj.name]?
      acc.data[obj.name] = obj
    else
      acc.data[obj.name] <<< obj
    acc.count += 1
  done acc

export function process_twgovdata_7620(acc, src, done)
  content = fs.readFileSync src, 'utf-8'
  $ = cheerio.load content, {+xmlMode}
  orgs = $ 'channel' .find 'item'
  get = (o, q) -> o.find q .text!
  orgs.each ->
    obj = do
      name: get @, 'title1'
      address: null
      other_names: []
      #@FIXME: parse contact details of node 7620.
      contact_details: []
      note: get @, 'description'
      links: []
    unless acc.data[obj.name]?
      acc.data[obj.name] = obj
    else
      acc.data[obj.name] <<< obj
    acc.count += 1
  done acc
