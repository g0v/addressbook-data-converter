expected_person = do
  id: 'http://www.ly.gov.tw/03_leg/0301_main/legIntro.action?lgno=00001&stage=8'
  name: "丁守中"
  other_names: []
  identifiers: []
  email: null
  gender: null
  birth_date: null
  death_date: null
  image: "http://avatars.io/50a65bb26e293122b0000073/36f800ccfad1a8429e795874b135b969"
  summary: null
  biography: null
  national_identity: null
  contact_details: [
    * label: "國會研究室電話"
      type: "voice"
      value: "02-2358-6706"
    * label: "國會研究室地址"
      type: "address"
      value: "10051臺北市中正區濟南路1段3-1號0707室"
    * label: "國會研究室傳真"
      type: "fax"
      value: "02-2358-6710"
    * label "北投服務處電話"
      type: "voice" 
      value: "02-2828-7789"
    * label: "北投服務處地址"
      type: "address"
      value: "11262臺北市北投區承德路七段188巷2號1樓"
    * label: "北投服務處傳真"
      type: "fax"
      value: "02-2828-6877"
  ] 
  links: []

expected_post = do
  id: 'ly-committe'
  label: '立法委員'
  role: '立法委員'
  organization_id: '立法院'
  start_date: null
  end_date: null
  contact_details: []
  links: []

expected_membership = do
  id: '8th-ly-committe http://www.ly.gov.tw/03_leg/0301_main/legIntro.action?lgno=00001&stage=8'
  label: "第八屆立法委員 丁守中"
  role: "立法委員"
  person_id: 'http://www.ly.gov.tw/03_leg/0301_main/legIntro.action?lgno=00001&stage=8'
  organization_id: '立法院'
  post_id: 'ly-committe'
  start_date: null
  end_date: null
  contact_details: []
  links: []