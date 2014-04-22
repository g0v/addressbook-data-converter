# # Person Processor
utils = require \./utils
org = require \./org
origin_municipality = [\臺北市, \高雄市]
new_municipality = [\新北市, \臺中市, \臺南市]

guess-twcomitte-session = (year) ->
  match year
  | /098/ => [(utils.date \2009, \10, \20), (utils.date \2014, \10, \20)]
  | /099/ => [(utils.date \2010, \10, \25), (utils.date \2014, \10, \25)]
  | _ => []

find-memeberships = (orgids, name, record) ->
  if record.orgname?
    orgname = org.normalized-name record.orgname
    posiname = "#{orgname}#{record.posiname}"
  else
    cityname = org.normalized-name record.cityname
    townname = org.normalized-name record.townname
    villname = org.normalized-name record.villname
    orgname = "#{cityname}#{townname}公所"
    posiname = "#{cityname}#{townname}#{villname}#{record.posiname}"
  [start_date, end_date] = guess-twcomitte-session record.electname
  organization_id = orgids[orgname]
  throw "orgname #{orgname} is missing." unless organization_id
  m = []
  m.push do
    label: "#{posiname}#{name}"
    role: record.posiname
    post_id: posiname
    orgnization_id: organization_id
    start_date: start_date,
    end_date: end_date
    contact_details:
      * label: \辦公室地址
        type: \address
        value: record.officeadress
      * label: \辦公室電話
        type: \voice
        value: record.officetelphone
    note: "#{record.eareaname}"

  if record.partymship and (record.partymship isnt \無政黨 and record.partymship isnt '')
    party_id = orgids[record.partymship]
    throw "can not find organization_id of #{record.partymship} in orgids" unless party_id
    m.push do
      label: "#{record.partymship}黨員#{name}"
      role: "黨員"
      post_id: "#{record.partymship}黨員"
      organization_id: party_id
  return m

popolized-record = (orgids, record) ->
  name = record.idname.replace "　", ""
  do
    name: name
    gender: match record.sex
            | /男/ => 'male'
            | /女/ => 'female'
            | _ => 'unknown'
    image: record.photograph
    summary: null
    biography: "#{record.education}\n#{record.profession}"
    national_identify: record.photograph
    memberships: find-memeberships orgids, name, record

travel-data = (acc, data, done) ->
  for record in data
    acc.data.push popolized-record acc.orgids, record
    acc.count +=1
  done acc

# ### 縣市議員 Porcessor
# ```
# - @param acc {data:{$orgname:$org}}, count:Int, orgids:{$orgname:$orgid}}
# - @param src String file path
# - @param done Function
# - @returns same as acc
# ```
export function process_twgovdata_7054(acc, src, done)
  #@FIXME: fix the path is not consist in test case.
  data = require require.resolve (src is /rawdata/ and "../#{src}" or src)
  travel-data acc , data, done

# ### 縣市議員 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7055 = process_twgovdata_7054
# ### 鄉鎮市民代表 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7056 = process_twgovdata_7054
# ### 直轄市市長 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7057 = process_twgovdata_7054
# ### 縣市市長 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7058 = process_twgovdata_7054
# ### 鄉鎮市長 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7059 = process_twgovdata_7054
# ### 區長 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7060 = process_twgovdata_7054
# ### 村里長 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7061 = process_twgovdata_7054
# ### 村里幹事 Porcessor
# ```
# - @alias `process_twgovdata_7054`
# ```
exports.process_twgovdata_7062 = process_twgovdata_7054
