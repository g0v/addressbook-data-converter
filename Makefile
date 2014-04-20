DB=mydb
boot:
	dropdb --if-exists ${DB}
	createdb ${DB}
	./node_modules/pgrest/./bin/pgrest --boot --db ${DB}
	psql ${DB} < addressbook-tpl.sql
build:
	./process-org-data.ls
	./populate-org-data.ls --db ${DB}
	./process-person-data.ls --db ${DB}
	./populate-person-data.ls --db ${DB}
	pg_dump ${DB} > output/addressbook.sql
rebuild: 
	psql -c "drop database ${DB};"
	make boot
	make build
