# # Person
# ## 立法委員
# ### 需要處理的身份
# - 第N屆立法委員
# - 第N屆立法院 ＸＸ委員會委員
# - 政黨身份

export function from_mly(json, done)
  person = []
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
  done 0, person
