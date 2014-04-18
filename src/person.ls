# # Person Processor
utils = require \./utils
origin_municipality = [\臺北市, \高雄市]
new_municipality = [\新北市, \臺中市, \臺南市]

#@FIXME: feadbak the pua to data.gov.tw.
guess-twcomitte-session = (orgname, year) ->
  city = orgname.replace \議會, ''
  if city in origin_municipality
    [\第五屆, (utils.date \2012, \12, \25), (utils.date \2014, \12, \25)]
  else if city in new_municipality
    [\第一屆, (utils.date \2012, \12, \25), (utils.date \2014, \12, \25)]
  else
    [\第十七屆, (utils.date \2009, \12, 20), (utils.date \2014, \12, \20)]

export function process_twgovdata_7054(acc, src, done)
  find-memeberships = (name, record) ->
    orgname = record.orgname.replace '台', '臺'
    [session, start_date, end_date] = guess-twcomitte-session orgname, record.electname
    posiname = "#{session}#{record.posiname}"
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
