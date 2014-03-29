prepare:
	npm run prepublish

build: prepare
	./addressbook-data-converter --input_file rawdata/organization/data-gov-node-7307-source.csv --output_file output/data-gov-node-7307.json --converter org.from_data_gov_7307
	./addressbook-data-converter --input_file rawdata/organization/data-gov-node-6119-source.csv --output_file output/data-gov-node-6119.json --converter org.from_data_gov_6119 --acc output/data-gov-node-7307.json
	./addressbook-data-converter --input_file rawdata/organization/data-gov-node-7437-source.xml --output_file output/data-gov-node-7437.json --converter org.from_data_gov_7437 --acc output/data-gov-node-6119.json
