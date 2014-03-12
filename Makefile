prepare:
	npm run prepublish

build: prepare
	./addressbook-data-converter --input_file rawdata/organization/data-gov-node-7307-source.csv --output_file output/data-gov-node-7307.json --converter org.from_data_gov_7307
	lsc populate-data-gov-node-6119.ls > output/allorg_tmp.json
	gsed -i s/orgName/orgname/g rawdata/organization/data-gov-node-7437-source.xml
	lsc populate-data-gov-node-7437.ls > output/allorg.json
