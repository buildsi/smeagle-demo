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

This demo will currently:

1. Install all versions of a package (zlib)
2. Use Smeagle to extract all model facts
3. Load the model facts into a database
4. Show what is added to the database (sanity check)
5. Use the database to generate facts and run a solve for the stability tests.


The whole thing looks like this:

```bash
$ docker run -it smeagle-db
==> Installing zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
==> No binary for zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/c3/c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
  Fetch: 0.29s.  Build: 1.92s.  Total: 2.21s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
==> Installing zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
==> No binary for zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/36/36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
  Fetch: 0.32s.  Build: 1.76s.  Total: 2.08s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
==> Installing zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
==> No binary for zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/17/1795c7d067a43174113fdf03447532f373e1c6c57c08d61d9e4e9be5e244b05e.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
  Fetch: 5.51s.  Build: 0.94s.  Total: 6.45s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
INFO:smeagle-db:Retrieving record for zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.json
INFO:smeagle-db:Retrieving record for zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.json
INFO:smeagle-db:zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.json
INFO:smeagle-db:zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.json
INFO:smeagle-db:Retrieving record for zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.json
INFO:smeagle-db:Retrieving record for zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.json
INFO:smeagle-db:Libraries are not stable: 0 missing exports, 19 missing_imports

Missing Imports
---------------
 deflateGetDictionary Pointer64 %rsi
 deflateGetDictionary Pointer64 %rdx
 crc32_z Integer64 %rdi
 crc32_z Pointer64 %rsi
 crc32_z Integer64 %rdx
 gzfread Pointer64 %rdi
 gzfread Integer64 %rsi
 gzfread Integer64 %rdx
 adler32_z Integer64 %rdi
 adler32_z Pointer64 %rsi
 adler32_z Integer64 %rdx
 inflateValidate Integer32 %rsi
 gzfwrite Pointer64 %rdi
 gzfwrite Integer64 %rsi
 gzfwrite Integer64 %rdx
 uncompress2 Pointer64 %rdi
 uncompress2 Pointer64 %rsi
 uncompress2 Pointer64 %rdx
 uncompress2 Pointer64 %rcx
```

Are those assertions correct? Well Smeagle isn't really done yet, so maybe not! :)
You can see the entire logic in [run.sh](run.sh) which uses [smeagle-db](smeagle-db) (python).

Specifically, once you have some libraries and have run Smeagle on those libraries to output
json, you can then run smeable-db to load and list:

```bash
# Load and list results
./smeagle-db load ./results/
./smeagle-db list
```
And run the stability test:

```
# Run stability test of one library vs. the other
tests=$(ls ./results)
./smeagle-db stability-test $tests --detail
```

To run interactively or develop, you probably want to bind the present working
directory. For the container, Smeagle is installed at `/code` and the files here are
added to `/db` so if you want to run and bind:

```bash
$ docker run -it --entrypoint bash -v $PWD:/db smeagle-db 

# run.sh will reproduce what you see above.
```

Please [open an issue](https://github.com/buildsi/smeagle-demo) if you have any questions!
