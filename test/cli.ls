should = (require \chai).should!
expect = (require \chai).expect

cli = (require \../) .cli!

describe 'CLI', ->
  describe 'dispather', -> ``it``
    .. 'should be able to find correct function.', (done) ->		
      cli.dispatch 'org', 'from_csv' .name.should.be.eq 'from_csv'
      done!
    .. 'should throw error if function is not found.', (done) ->    
      (-> cli.dispatch 'orgs', 'invlaid').should.throw 'orgs is not a module.'
      (-> cli.dispatch 'org', 'invlaid').should.throw 'invlaid is not a function.'
      done!