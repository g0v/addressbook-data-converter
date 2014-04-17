DB=mydb
boot:
	createdb ${DB}
	./node_modules/pgrest/./bin/pgrest --boot --db ${DB}
	psql ${DB} < addressbook-tpl.sql
build:
	./process-data.ls
	./populate-org-data.ls --db ${DB}
	./process-person-data.ls --db ${DB}
	./populate-person-data.ls --db ${DB}
