# # Person Processor
utils = require \./utils
origin_municipality = [\臺北市, \高雄市]
new_municipality = [\新北市, \臺中市, \臺南市]

#@FIXME: feadbak the pua to data.gov.tw.
guess-twcomitte-session = (year) ->
  match year
  | /098/ => [(utils.date \2009, \10, \20), (utils.date \2014, \10, \20)]
  | /099/ => [(utils.date \2010, \10, \25), (utils.date \2014, \10, \25)]
  | _ => []

export function process_twgovdata_7054(acc, src, done)
  find-memeberships = (name, record) ->
    orgname = record.orgname.replace '台', '臺'
    [start_date, end_date] = guess-twcomitte-session record.electname
    posiname = "#{record.posiname}"
    organization_id = acc.orgids[orgname]
    console.log orgname unless organization_id
    m = []
    m.push do
      label: "#{orgname}#{posiname}#{name}"
      role: record.posiname
      post_id: "#{orgname}#{posiname}"
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
      party_id = acc.orgids[record.partymship]
      throw "can not find organization_id of #{record.partymship} in orgids" unless party_id
      m.push do
        label: "#{record.partymship}黨員#{name}"
        role: "黨員"
        post_id: "#{record.partymship}黨員"
        organization_id: party_id
    return m

  #@FIXME: fix the path is not consist in test case.
  data = require require.resolve (src is /rawdata/ and "../#{src}" or src)
  for record in data
    name = record.idname.replace "　", ""
    acc.data.push do
      name: name
      gender: match record.sex
              | /男/ => 'male'
              | /女/ => 'female'
              | _ => 'unknown'
      image: record.photograph
      summary: null
      biography: "#{record.education}\n#{record.profession}"
      national_identify: record.photograph
      memberships: find-memeberships name, record
    acc.count +=1
  done acc

exports.process_twgovdata_7055 = process_twgovdata_7054
