from_csv = require \./lib .org! .from_csv

orgmap = {}
orgs = require \./output/data-gov-node-7307.json
root = ''
for org in orgs
  orgmap[org.name] = org

path = \./rawdata/organization/data-gov-node-6119-source.csv
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

result, count <-  from_csv path, opts, _cb
console.log JSON.stringify orgmap, null, 4