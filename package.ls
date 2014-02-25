#!/usr/bin/env lsc -cj
author:
  name: ['Chen Hsin-Yi']
  email: 'ossug.hychen@gmail.com'
name: 'whoswho'
description: 'who is who?'
version: '0.0.1'
main: \lib/index.js
repository:
  type: 'git'
  url: 'git://github.com/g0v/whoswho.git'
scripts:
  test: """
    mocha
  """
  prepublish: """
    lsc -cj package.ls &&
    lsc -bc -o lib src
  """
  # this is probably installing from git directly, no lib.  assuming dev
  postinstall: """
    if [ ! -e ./lib ]; then npm i LiveScript; lsc -bc -o lib src; fi
  """
engines: {node: '*'}
dependencies:
  optimist: \0.6.x  
  jsonld: \0.1.x
  csv: \*
devDependencies:
  mocha: \1.14.x
  supertest: \0.7.x
  chai: \1.8.x
  LiveScript: \1.2.x
