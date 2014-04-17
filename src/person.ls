export function process_twgovdata_7054(acc, src, done)
  find-memeberships = (name, record) ->
    #@FIXME: feadbak the pua to data.gov.tw.
    orgname = record.orgname.replace '台', '臺'
    m = []
    organization_id = acc.orgids[orgname]
    console.log orgname unless organization_id
    m.push do
      label: "#{orgname}#{record.posiname}#{name}"
      role: record.posiname
      post_id: record.posiname
      orgnization_id: organization_id
      contact_details:
        * label: \辦公室地址
          type: \address
          value: record.officeaddress
        * label: \辦公室電話
          type: \voice
          value: record.officephone
      note: "#{record.eareaname}"

    if record.partymship and (record.partymship isnt \無政黨 and record.partymship isnt '')
      party_id = acc.orgids[record.partymship]
      throw "can not find organization_id of #{record.partymship} in orgids" unless party_id
      m.push do
        label: "#{record.partymship}黨員"
        role: "黨員"
        post_id: "黨員"
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
