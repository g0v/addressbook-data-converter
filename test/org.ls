require! fs
should = (require \chai).should!
expect = (require \chai).expect

from_data_gov_7307 = (require \../).org! .from_data_gov_7307
from_data_gov_6119 = (require \../).org! .from_data_gov_6119
from_data_gov_7437 = (require \../).org! .from_data_gov_7437
convert_data = (require \../).cli! .convert_data

describe 'Organization', ->
  expected_obj = do
    name: "內政部土地測量局"
    other_names: [
      "name": "內政部國土測繪中心",
      "start_date": "Thu Dec 06 2007 00:00:00 GMT+0800 (CST)",
      "end_date": null
    ]
    identifiers: [
            * identifier: \301080000G
              scheme: \orgcode
            ]
    classification: \3
    parent_id: \301000000A
    founding_date: null
    dissolution_date: "Thu Dec 06 2007 00:00:00 GMT+0800 (CST)"
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
  describe 'process data.gov.tw node 7307.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      orgs, count <- from_data_gov_7307 [], \test/testdata/organization/data-gov-node-7307-source.csv
      count.should.eq 5
      orgs.length.should.eq 5
      orgs.0.should.deep.eq expected_obj
      done!
  describe 'convert orglist to json.', -> ``it``
    afterEach (done) ->
      <- fs.unlink \test/testdata/orglist.out.json
      done!
    .. 'should be able to process sync.', (done) ->
      err, count <- convert_data 'org.from_data_gov_7307', [], \test/testdata/organization/data-gov-node-7307-source.csv, \test/testdata/organization/data-gov-node-7307-source.json
      count.should.eq 5
      done!
  describe 'process data.gov.tw node 6119.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      orgs, count <- from_data_gov_6119 [], \test/testdata/organization/data-gov-node-6119-source.csv
      count.should.eq 117
      orgs.length.should.eq 117
      orgs.0.name.should.eq \駐清奈辦事處
      done!
  describe 'process data.gov.tw node 7437.', -> ``it``
    .. 'should contain elements follow popolo specs.', (done) ->
      orgs, count <- from_data_gov_7437 [], \test/testdata/organization/data-gov-node-7437-source.xml
      done!
