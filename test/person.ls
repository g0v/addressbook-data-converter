require! path

should = (require \chai).should!
expect = (require \chai).expect

from_mly = (require \../).person! .from_mly

expected_person = do
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
  contact_details: []
  links: []

describe 'Person', ->
  describe 'load mly as array.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      o = require path.resolve 'test/testdata/person/github-g0v-twlyparser-mly-8.json'
      o.should.be.ok
      err, person, memberships <- from_mly o
      person.0.should.deep.eq expected_person
      memberships.0.role.should.eq \立法委員
      done!
