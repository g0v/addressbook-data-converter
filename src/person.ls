# # Person
# ## 立法委員
# ### 需要處理的身份
# - 第N屆立法委員
# - 第N屆立法院 ＸＸ委員會委員
# - 政黨身份

popolized_mly_person = ->
  transform_contact = ->
    r = []
    for unit_name, unit_info of it
      r.push do
        label: "#{unit_name}電話"
        type: "voice"
        value: unit_info.phone
      r.push do
        label: "#{unit_name}地址"
        type: "address"
        value: unit_info.address
      r.push do
        label: "#{unit_name}傳真"
        type: "fax"
        value: unit_info.fax
    r

  do
    id: 0
    name: it.name
    other_names: []
    identifiers: []
    gender: null
    birth_date: null
    death_date: null
    image: it.avatar
    summary: null
    biography: null
    national_identity: null
    contact_details: it.contact and transform_contact it.contact or []
    links: []

popolized_mly_membership = ->

popolized_mly_org = ->

export function from_mly(json, done)
  person = []
  memberships = []
  orgs = []
  for record in json
    person.push popolized_mly_person record
    memberships.push popolized_mly_membership record
    orgs.push popolized_mly_org record
  done [0, person, memberships]
