require! path

should = (require \chai).should!
expect = (require \chai).expect

from_mly = (require \../).person! .from_mly

expected_person = do
  id: 0
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
  contact_details: []
  links: []

describe 'Person', ->
  describe 'load mly as array.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      o = require path.resolve 'test/testdata/person/github-g0v-twlyparser-mly-8.json'
      o.should.be.ok
      [err, person, memberships, orgs] <- from_mly o
      person.0.should.deep.eq expected_person
      done!
