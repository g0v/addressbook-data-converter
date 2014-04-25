# # Person Processor
require! fs
utils = require \./utils
org = require \./org
origin_municipality = [\臺北市, \高雄市]
new_municipality = [\新北市, \臺中市, \臺南市]

partycode = (code) ->
  match code
  | \KMT => \中國國民黨
  | \DPP => \民主進步黨
  | \TSU => \台灣團結聯盟
  | \NSU => \無黨團結聯盟
  | \PFP => \親民黨
  | \NP => \新黨
  | \TIP => \建國黨
  | \CPU => \超黨派問政聯盟
  | \DU => \民主聯盟
  | \NNA => \新國家陣線
  | _ => null

new-party-record = (orgids, name, partyname) ->
  posiname = "#{partyname}黨員"
  party_id = orgids[partyname]
  throw "can not find corresponding id of #{partyname}" unless party_id
  do
    label: "#{posiname}#{name}"
    role: \黨員
    post_id: posiname
    organization_id: party_id

normalized-gender = (gender) ->
  throw "gender is missing." unless gender
  match gender
  | /男/ => \male
  | /女/ => \female
  | _ => \unknown

guess-twcomitte-session = (year) ->
  match year
  | /098/ => [(utils.date \2009, \10, \20), (utils.date \2014, \10, \20)]
  | /099/ => [(utils.date \2010, \10, \25), (utils.date \2014, \10, \25)]
  | _ => []

find-twgovdata7054-memeberships = (orgids, name, record) ->
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
  throw "orgname #{orgname}} is missing." unless organization_id
  m = []
  newrecord = do
    label: "#{posiname}#{name}"
    role: record.posiname
    post_id: posiname
    orgnization_id: organization_id
    start_date: start_date,
    end_date: end_date
    contact_details: []
  if record.officeadress
    newrecord.contact_details.push do
      * label: \辦公室地址
        type: \address
        value: record.officeadress
  if record.officetelphone
    newrecord.contact_details.push do
      * label: \辦公室電話
        type: \voice
        value: record.officetelphone
  if record.eareaname
    newrecord.note: "#{record.eareaname}"
  m.push newrecord

  if record.partymship and (record.partymship isnt \無政黨 and record.partymship isnt '')
    m.push new-party-record orgids, name, record.partymship
  return m

popolized-twgovdata7054-record = (orgids, record) ->
  name = record.idname.replace "　", ""
  do
    name: name
    gender: normalized-gender record.sex
    image: record.photograph
    summary: null
    biography: "#{record.education}\n#{record.profession}"
    national_identify: record.photograph
    memberships: find-twgovdata7054-memeberships orgids, name, record

# ### 縣市議員 Porcessor
# ```
# - @param acc {data:{$orgname:$org}}, count:Int, orgids:{$orgname:$orgid}}
# - @param src String file path
# - @param done Function
# - @returns same as acc
# ```
export function process_twgovdata_7054(acc, src, done)
  data = JSON.parse fs.readFileSync src, 'utf-8'
  utils.travel-data acc, data, popolized-twgovdata7054-record, done

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

# ### 立委 Porcessor
# To process lygislactor informations which are produced by [twlycralwer]https://github.com/g0v/twly_crawler()
# project.
#
# ```
# - @param acc {data:{$orgname:$org}}, count:Int, orgids:{$orgname:$orgid}}
# - @param src String file path
# - @param done Function
# - @returns same as acc
# ```
export function process_github_mly(acc, src, done)
  data = JSON.parse fs.readFileSync src, 'utf-8'
  utils.travel-data acc, data, popolized-github-mly-record, done

popolized-github-mly-record = (orgids, record) ->
  newrecord = do
    name: record.name
    image: record.image
    gender: normalized-gender record.gender
    # use ly.gov.tw ID as national_identify.
    national_identify: record.id
    summary: ''
    biography: ''
    memberships: find-github-mly-memberships orgids, record.name, record
  if record.education
    newrecord.biography += record.education.join "\n"
  if record.experience
    newrecord.biography += record.experience.join "\n"
  return newrecord

find-github-mly-memberships = (orgids, name, record) ->
  m = []
  partyname = partycode record.caucus
  organization_id = orgids["立法院"]
  throw "orgids does not has 立法院" unless organization_id
  newrecord = do
    label: "第#{record.ad}屆立法委員#{name}"
    role: "立法委員"
    posiname: "立法院立法委員"
    organization_id: orgids["立法院"]
    start_date: record.term_start
    links: [{note:l, url:v} for l,v of record.links]
    #@FIXME: committees data is not in popolo form.
    committees: record.committees
    contact_details: []
  #Lygislactor who quit does not has contact details.
  if record.contacts
    for r in record.contacts
      for k,v of r
        if k is \name
          continue
        type = k is \phone and \voice or k
        typename = switch type
                  | \voice => \電話
                  | \fax => \傳真
                  | \address => \地址
        newrecord.contact_details.push do
                                  label: "#{r.name}#{typename}"
                                  type: type
                                  value: v
  #@FIXME: poplo spec does not define terminate reason and replacement relationship.
  if record.term_end and record.term_end
    [y,mm,d] =(record.term_end.date / \-)
    newrecord.end_date = utils.date y,mm,d
  if record.remark
    newrecord.note = record.remark
  m.push newrecord

  #Some Lygislactor does not belongs any party.
  if partyname
    m.push new-party-record orgids, name, partyname
  m
