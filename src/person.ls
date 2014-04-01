# # Person
# ## 立法委員
# ### 需要處理的身份
# - 第N屆立法委員
# - 第N屆立法院 ＸＸ委員會委員
# - 政黨身份

export function from_mly(json, done)
  transform_contact = ->
    r = []
    for unit_name, unit_info of it
      for label, value of unit_info
        label_msg = match label
        | \phone => \電話
        | \address => \地址
        | \fax => \傳真
        | otherwise => console.error label
        type = label is \phone and \voice or label

        r.push do
          label: "#{unit_name}#{label_msg}"
          type: type
          value: value
    r
  person = []
  memberships = []
  for record in json
    person.push do
      name: record.name
      other_names: []
      identifiers: []
      gender: null
      birth_date: null
      death_date: null
      image: record.avatar
      summary: null
      biography: null
      national_identity: null
      contact_details:[]
      links: []
    memberships.push do
      label: '中華民國立法院第八屆立法委員'
      role: '立法委員'
      person_id: record.name
      post_id: '中華民國立法委員'
      organization_id: '立法院'
      start_date: new Date record.assume
      end_date: new Date '2016/01/31'
      contact_details: transform_contact record.contact
      links: []
  done 0, person, memberships
