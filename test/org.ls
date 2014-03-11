require! fs
should = (require \chai).should!
expect = (require \chai).expect

from_orglist = (require \../).org! .from_orglist
convert_orglist = (require \../).org! .convert_orglist

describe 'Organization', ->
  expected_obj = do
    name: "內政部國土測繪中心"
    other_names: [
            * name: \內政部土地測量局
              start_date: null
              end_date: "Thu Dec 06 2007 00:00:00 GMT+0800 (CST)"
            ]
    identifiers: [
            * identifier: \301000100G
              scheme: \orgcode
            ]
    classification: \3
    parent_id: \301000000A
    founding_date: "0961106"
    dissolution_date: null
    image: null
    contact_details : [
            * label: \機關電話
              type: \voice
              value: \04-22522966-
              source: null 
            * label: \機關傳真
              type: \fax
              value: \04-22543403-
              source: null ]
    links: []
  describe 'load orglist as array.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      orgs, count <- from_orglist \test/testdata/organization/data-gov-node-7307-source.csv
      count.should.eq 5
      orgs.length.should.eq 5
      orgs.0.should.deep.eq expected_obj
      done!
  describe 'convert orglist to json.', -> ``it``
    afterEach (done) ->
      <- fs.unlink \test/testdata/orglist.out.json
      done!
    .. 'should be able to process sync.', (done) ->
      err, count <- convert_orglist \test/testdata/organization/data-gov-node-7307-source.csv, \test/testdata/organization/data-gov-node-7307-source.json
      count.should.eq 5
      done!
