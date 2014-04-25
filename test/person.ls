should = (require \chai).should!
expect = (require \chai).expect
person = (require \../lib/person)

orgids = do
  "臺北市松山區公所": 1
  "中國國民黨":1
  "中國青年黨": 1
  "中國民主社會黨": 1
  "建國黨": 2
  "民主聯盟": 2
  "全國民主非政黨聯盟" : 2
  "台灣吾黨" : 2
  "無黨團結聯盟" : 2
  "民主進步黨": 2
  "勞動黨": 3
  "台灣團結聯盟": 4
  "親民黨": 5
  "新黨": 6
  "綠黨": 7
  "基隆市議會": 8
  "臺北市議會": 8
  "新北市議會": 8
  "桃園縣議會": 8
  "金門縣議會": 8
  "福建省連江縣議會": 8
  "澎湖縣議會": 8
  "花蓮縣議會": 8
  "花蓮市議會": 8
  "雲林市議會": 8
  "雲林縣議會": 8
  "南投市議會": 8
  "南投縣議會": 8
  "彰化市議會": 8
  "彰化縣議會": 8
  "苗栗市議會": 8
  "苗栗縣議會": 8
  "屏東市議會": 8
  "屏東縣議會": 8
  "嘉義縣議會": 8
  "嘉義市議會": 8
  "臺東市議會": 8
  "臺東縣議會": 8
  "新竹縣議會": 8
  "新竹市議會": 8
  "宜蘭縣議會": 8
  "宜蘭市議會": 8
  "臺中市議會": 8
  "臺南市議會": 8
  "高雄市議會": 8
  "立法院": 9
describe 'Person Converter', ->
  describe 'processing data.gov.tw node 7054.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_twgovdata_7054 acc, \./test/testdata/person/source-twgovdata-7054.json
      acc.data.0.name.should.eq '張建榮'
      acc.data.0.memberships.0.role.should.eq '議長'
      acc.data.0.memberships.1.role.should.eq '黨員'
      acc.data.0.memberships.1.organization_id.should.eq 1
      acc.count.should.eq 575
      done!
  describe 'processing data.gov.tw node 7055.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_twgovdata_7055 acc, \./test/testdata/person/source-twgovdata-7055.json
      acc.data.0.name.should.eq '吳碧珠'
      acc.data.0.memberships.0.role.should.eq '議長'
      acc.data.0.memberships.1.role.should.eq '黨員'
      acc.data.0.memberships.1.organization_id.should.eq 1
      acc.count.should.eq 304
      done!
  describe 'processing data.gov.tw node 7061.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_twgovdata_7061 acc, \./test/testdata/person/source-twgovdata-7061.json
      acc.data.0.memberships.0.label.should.be.eq "臺北市松山區莊敬里里長劉美鳳"
      done!
  describe 'processing data.gov.tw node 7062.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_twgovdata_7062 acc, \./test/testdata/person/source-twgovdata-7062.json
      acc.data.0.memberships.0.label.should.be.eq "臺北市松山區莊敬里里幹事詹雅菁"
      done!
  describe 'processing github mly.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      acc = {data: [], count: 0, orgids: orgids}
      acc <- person.process_github_mly acc, \./test/testdata/person/source-github-mly.json
      acc.count.should.eq 1728
      acc.data.0.name.should.eq \卜少夫
      acc.data.0.memberships.length.should.eq 2
      done!
