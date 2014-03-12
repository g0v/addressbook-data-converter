# # Conveter

# An function that its name starts with `convert` will known as a convter in 
# this project and could be used in a dispatch function. 
# 
# The converter simply processes only one data source (which usually located in `rawdata` 
# directory) and generate converted data (which usually located in `output` directory).
# 
# The dispatch function is used to lookup correct convert to do the following 
# data converting. 
# 
# [note] All convter acceppts 2 aurgements.

# ## Example
# ``
# $ addressbook-data-converter --input_file rawdata/central/orglist.CSV --output_file output/orglist.json
# ``
require! fs

parse_converter = ->
  q = it / '.'
  throw 'invalid query' if q.length != 2
  q

export function dispatch(q, fnname) 
  [modname, fnname] = parse_converter q
  pkg = require \./
  throw "#modname is not a module." unless pkg[modname]?
  module = pkg[modname]!
  fn = module[fnname]
  throw "#fnname is not a function." unless typeof fn is \function 
  fn

export function convert_data(name, path, dest, done) 
  result, count <- (dispatch name) path
  json = JSON.stringify result, null, 4
  err <- fs.writeFile dest, json
  done err, count