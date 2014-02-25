should = (require \chai).should!
expect = (require \chai).expect

from_orglist = (require \../).org! .from_orglist

describe 'Organization', ->
  describe 'source: orglist', -> ``it``
    .. 'from orglist', (done) ->
      expected_obj = do
        name: "內政部國土測繪中心"
        other_names: [
            * name: \內政部土地測量局
              start_date: null
              end_date: "0961106"
            ]
        identifiers: [
            * identifier: \301000100G
              scheme: \orgcode
            ]
        classification: \3
        parent_id: null
        founding_date: "0961106"
        dissolution_date: null
        image: null
        contact_details : [
            * label_zh: \機關電話
              type: \voice
              value: \04-22522966-
              source: null 
            * label_zh: \機關傳真
              type: \fax
              value: \04-22543403-
              source: null ]
        links: []
      orgs, count <- from_orglist \test/testdata/orglist.CSV 
      count.should.eq 5
      orgs.length.should.eq 5
      orgs.0.should.deep.eq expected_obj
      done!