require! fs
should = (require \chai).should!
expect = (require \chai).expect
org = (require \../lib/org)

describe 'Organization Converter', ->
  describe 'processing data.gov.tw node 7307.', -> ``it``
    .. 'should follow popolo specs.', (done) ->
      expected_obj = do
        name: "內政部土地測量局"
        other_names: [
          "name": "內政部國土測繪中心",
          "start_date": "Thu Dec 06 2007 00:00:00 GMT+0800 (CST)",
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
        contact_details : 
                * label: \機關電話
                  type: \voice
                  value: \04-22522966-
                * label: \機關傳真
                  type: \fax
                  value: \04-22543403-
        links: []
        sources:
          * url: \http://data.gov.tw/node/7307
      result <- org.process_twgovdata_7307 {data:[], count:0},
                   \./test/testdata/organization/data-gov-node-7307-source.csv
      result.data['內政部土地測量局'].should.deep.eq expected_obj
      result.count.should.eq 5
      done!
    .. 'should update acc data and count', (done) ->
        acc ={data:{'中國國民黨': {'name':'中國國民黨'}}, count:1}
        result <- org.process_twgovdata_7307 acc, 
                     \./test/testdata/organization/data-gov-node-7307-source.csv
        result.count.should.eq 6
        done!
  describe 'processing data.gov.tw node 6119.', -> ``it``
    .. 'should follw popolo spec.', (done) ->
      acc = {data:{}, count: 0}
      result <- org.process_twgovdata_6119 acc, 
                   \./test/testdata/organization/data-gov-node-6119-source.csv
      result.data['駐聖文森國大使館'].name.should.eq \駐聖文森國大使館
      result.count.should.eq 117
      done!
    .. 'should update acc data and count.', (done) ->
      acc = {data:{'駐聖文森國大使館': {+testbit}}, count: 1}
      result <- org.process_twgovdata_6119 acc, 
                   \./test/testdata/organization/data-gov-node-6119-source.csv
      result.data['駐聖文森國大使館'].testbit.should.be.ok
      result.count.should.eq 118
      done!
  describe 'processing data.gov.tw node 7437.', -> ``it``
    .. 'should follow popolo spec', (done) ->
      acc = {data: {}, count: 0}
      result <- org.process_twgovdata_7437 acc, 
                   \./test/testdata/organization/data-gov-node-7437-source.xml
      result.data['內政部戶政司'].name.should.eq \內政部戶政司
      result.count.should.eq 342
      done!
  describe 'processing data.gov.tw node 7620.', -> ``it``
    .. 'should follow popolo spec', (done) ->
      acc = {data: {}, count: 0}
      result <- org.process_twgovdata_7620 acc, 
                   \./test/testdata/organization/data-gov-node-7620-source.xml
      result.data['內政部地政司'].name.should.eq \內政部地政司
      result.count.should.eq 
      done!