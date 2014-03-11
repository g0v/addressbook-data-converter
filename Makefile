prepare:
	npm run prepublish

build: prepare
	./addressbook-data-converter --input_file rawdata/organization/data-gov-node-7307-source.csv --output_file output/data-gov-node-7307.json --converter org.convert_orglist
	lsc populate-data-gov-node-6119.ls > output/allorg.json
