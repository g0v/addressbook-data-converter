# addressbook-data-convert

To convert Taiwan government organization rawdata from multiple sources in [popolo project] (http://popoloproject.com) specification.

The sources of rawdata can be found in file `data-index.json`.

[Document](http://g0v.github.io/addressbook-data-converter)

## Installation

```
$ npm i
```

## Update Source Properties

```
$ lsc update-data-index.ls
```

## Generate Final Data

The database name for building is `mydb` by default 
and you don't need to create it manually. The `make boot`
command will do it.

```
$ make boot
$ make build
```

NOTED: if your pg module got some errors, try `npm rebuild pg` 
 
After building, an dumped sqlfile can be find in `output/addressbook.sql`.

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
