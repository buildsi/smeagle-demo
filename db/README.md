# Database Smeagle

This demo version is going to:

1. Install all versions of a package from spack (zlib)
2. For each library that is discovered, dump model facts (json)
3. For each pair of model facts, import them into a sqlite database
4. Allow for query to run solves.

First build the container:

```bash
$ docker build -t smeagle-db .
```

To run the whole thing:

```bash
$ docker run -it smeagle-db
```

This will currently load the results into the database, and then show you the entries
are loaded:

```bash
INFO:smeagle-db:Creating record for zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.json
INFO:smeagle-db:Creating record for zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.json
INFO:smeagle-db:zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.json
INFO:smeagle-db:zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.json
```

This is done by way of running smeagle-db load and list:

```bash
./smeagle-db load ./results/
./smeagle-db list
```

To run interactively or develop, you probably want to bind the present working
directory. For the container, Smeagle is installed at `/code` and the files here are
added to `/db` so if you want to run and bind:

```bash
$ docker run -it --entrypoint bash -v $PWD:/db smeagle-db 

# run.sh will install specs and create database and list results
```
