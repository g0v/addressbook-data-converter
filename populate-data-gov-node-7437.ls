from_data_gov_7437 = require \./lib .org! .from_data_gov_7437
acc = require \./output/allorg_tmp.json
path = 'rawdata/organization/data-gov-node-7437-source.xml'
result, count <- from_data_gov_7437 acc, path
console.log JSON.stringify result, null, 4
