export function dispatch(modname, fnname) 
  pkg = require \./
  throw "#modname is not a module." unless pkg[modname]?
  module = pkg[modname]!
  fn = module[fnname]
  throw "#fnname is not a function." unless typeof fn is \function 
  fn

