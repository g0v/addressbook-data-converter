# addressbook-data-convert

To convert Taiwan government organization rawdata from multiple sources in [popolo project] (http://popoloproject.com) specification.

The sources of rawdata can be found in file `data-index.json`.

## Installation

```
$ npm i
```

## Update Source Properties

```
$ lsc update-data-index.ls
```

## Generate Final Data

```
$ ./process-org-data.ls
$ ./populate-org-data.ls --db mydb
$ ./populate-person-data.ls --db mydb
```

## Test 

```
$ npm test
```

## Build Documents

```
$ pip install Pygments
$ npm i groc
$ ./node_modules/groc/.bin/groc
```

The documents will be in the gh-pages branch.

## Reference
- []
