should = (require \chai).should!
expect = (require \chai).expect
utils = (require \../lib/utils)

describe 'Utilities', ->
  describe 'guess processor by set', -> ``it``
    .. 'should find corressponding processor by data.gov.tw node uri.', (done) ->
      processor = utils.guess-processor \organization, {url:"https://data.gov.tw/node/7307"}
      processor.name.should.eq \process_twgovdata_7307
      done!
    .. 'should find corressponding processor if the data is a native file.', (done) ->
      set = {url: "file://../test/testdata/organization/native-twparties.json"}
      processor = utils.guess-processor \organization, set
      processor.name.should.eq \process_nativedata
      acc <- processor {data:{}, count:0}, \./test/testdata/organization/native-twparties.json
      done!
    .. 'should find corressponding processor if the a processor name is given', (done) ->
      set = {url:"https://data.gov.tw", processor: "process_github_mly"}
      processor = utils.guess-processor \person, set
      processor.name.should.eq \process_github_mly
      done!
    .. 'should return null if processor is not found.', (done) ->
      processor = utils.guess-processor \organization, {url: "https://data.gov.tw/node/9999"}
      expect processor .to.be.not.k
      done!
