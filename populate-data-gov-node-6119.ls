from_data_gov_6119 = require \./lib .org! .from_data_gov_6119
acc = require \./output/data-gov-node-7307.json
path = \./rawdata/organization/data-gov-node-6119-source.csv
result, count <- from_data_gov_6119 acc, path
console.log JSON.stringify result, null, 4
