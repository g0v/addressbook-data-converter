should = (require \chai).should!
expect = (require \chai).expect
person = (require \../lib/person)

orgids = {"中國國民黨":1, "民主進步黨": 2, "勞動黨": 3, "台灣團結聯盟": 4, "親民黨": 5, "新黨": 6, "綠黨": 7}
describe 'Person Converter', ->
  describe 'processing data.gov.tw node 7054.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_twgovdata_7054 acc, \../test/testdata/person/source-twgovdata-7054.json
      acc.data.0.name.should.eq '張建榮'
      acc.data.0.memberships.0.role.should.eq '議長'
      acc.data.0.memberships.1.role.should.eq '黨員'
      acc.data.0.memberships.1.organization_id.should.eq 1
      acc.count.should.eq 575
      done!
  describe 'processing data.gov.tw node 7055.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_twgovdata_7055 acc, \../test/testdata/person/source-twgovdata-7055.json
      acc.data.0.name.should.eq '吳碧珠'
      acc.data.0.memberships.0.role.should.eq '議長'
      acc.data.0.memberships.1.role.should.eq '黨員'
      acc.data.0.memberships.1.organization_id.should.eq 1
      acc.count.should.eq 304
      done!
