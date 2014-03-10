should = (require \chai).should!
expect = (require \chai).expect
require! fs

{parse-set-datagov} = (require \../lib/crawer)

describe 'Crawer', ->
  describe 'fetch data from http://data.gov.tw.', -> ``it``
    .. 'should find out the data name.', (done) ->
      content = fs.readFileSync \./test/testdata/node-7307-source.html, 'utf-8'
      [name, url, rfname, ext] = parse-set-datagov content
      name.should.eq '行政院所屬中央及地方機關代碼'
      url.should.eq 'http://svrorg.dgpa.gov.tw/cpacode/file/orglist.CSV'
      done!