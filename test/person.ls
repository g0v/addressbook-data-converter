require! path

should = (require \chai).should!
expect = (require \chai).expect

from_mly = (require \../).person! .from_mly

expected_person = do
  id: 0
  name: "丁守中"
  other_names: []
  identifiers: []
  gender: null
  birth_date: null
  death_date: null
  image: "http://avatars.io/50a65bb26e293122b0000073/36f800ccfad1a8429e795874b135b969"
  summary: null
  biography: null
  national_identity: null
  contact_details: [
      {
        "label": "國會研究室電話",
        "type": "voice",
        "value": "02-2358-6706"
      },
      {
        "label": "國會研究室地址",
        "type": "address",
        "value": "10051臺北市中正區濟南路1段3-1號0707室"
      },
      {
        "label": "國會研究室傳真",
        "type": "fax",
        "value": "02-2358-6710"
      },
      {
        "label": "北投服務處電話",
        "type": "voice",
        "value": "02-2828-7789"
      },
      {
        "label": "北投服務處地址",
        "type": "address",
        "value": "11262臺北市北投區承德路七段188巷2號1樓"
      },
      {
        "label": "北投服務處傳真",
        "type": "fax",
        "value": "02-2828-6877"
      }
  ]
  links: []

describe 'Person', ->
  describe 'load mly as array.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      o = require path.resolve 'test/testdata/person/github-g0v-twlyparser-mly-8.json'
      o.should.be.ok
      [err, person, memberships, orgs] <- from_mly o
      person.0.should.deep.eq expected_person
      done!
