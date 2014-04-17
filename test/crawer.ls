should = (require \chai).should!
require! fs

{parse-set-prop-twgovdata} = (require \../lib/crawer)

describe 'Crawer', ->
  describe 'fetch data from http://data.gov.tw.', -> ``it``
    .. 'should find out its properties, e.x. update frequency.', (done) ->
      content = fs.readFileSync \./test/testdata/node-7307-source.html, 'utf-8'
      prop = parse-set-prop-twgovdata content
      prop.name.should.eq '行政院所屬中央及地方機關代碼'
      prop.uri.should.eq 'http://svrorg.dgpa.gov.tw/cpacode/file/orglist.CSV'
      prop.ext.should.eq 'csv'
      prop.update-freq.should.eq '每日'
      done!
