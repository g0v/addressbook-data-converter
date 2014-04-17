should = (require \chai).should!
expect = (require \chai).expect
utils = (require \../lib/utils)

describe 'Utilities', ->
  describe 'guess processor by set', -> ``it``
    .. 'should find corressponding processor by data.gov.tw node uri.', (done) ->
      processor = utils.guess-processor \organization, {url:"https://data.gov.tw/node/7307"}
      processor.name.should.eq \process_twgovdata_7307
      done!
    .. 'should return null if processor is not found.', (done) ->
      processor = utils.guess-processor \organization, {url: "https://data.gov.tw/node/9999"}
      expect processor .to.be.not.k
      done!