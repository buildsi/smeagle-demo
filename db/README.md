# Database Smeagle

This demo version is going to:

1. Install all versions of a package from spack (zlib)
2. For each library that is discovered, dump model facts (json)
3. For each pair of model facts, import them into a sqlite database
4. Allow for query to run solves.

## Build or Install

First build the container:

```bash
$ docker build -t smeagle-db .
```

Alternatively, if you want to create an environment locally (without Docker) you can follow the same 
steps as the [Dockerfile](Dockerfile), primarily creating a virtual environment with
Python, installing gringo/clingo on your system, and then installing requirements.txt.

## Stability Tests

### 1. Run Full Demo

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
  Fetch: 0.61s.  Build: 2.02s.  Total: 2.63s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
==> Installing zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
==> No binary for zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/36/36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
  Fetch: 0.92s.  Build: 1.91s.  Total: 2.83s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
==> Installing zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
==> No binary for zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/17/1795c7d067a43174113fdf03447532f373e1c6c57c08d61d9e4e9be5e244b05e.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
  Fetch: 1.08s.  Build: 1.04s.  Total: 2.12s.
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
 gzfread Pointer %rdi 1
 gzfread Integer %rsi 0
 gzfread Integer %rdx 0
 inflateValidate Integer %rsi 0
 adler32_z Integer %rdi 0
 adler32_z Pointer %rsi 1
 adler32_z Integer %rdx 0
 gzfwrite Pointer %rdi 1
 gzfwrite Integer %rsi 0
 gzfwrite Integer %rdx 0
 uncompress2 Pointer %rdi 1
 uncompress2 Pointer %rsi 1
 uncompress2 Pointer %rdx 1
 uncompress2 Pointer %rcx 1
 crc32_z Integer %rdi 0
 crc32_z Pointer %rsi 1
 crc32_z Integer %rdx 0
 deflateGetDictionary Pointer %rsi 1
 deflateGetDictionary Pointer %rdx 1
```

Or watch the demo!

[![asciicast](https://asciinema.org/a/426799.svg)](https://asciinema.org/a/426799)

Are those assertions correct? Well Smeagle isn't really done yet, so maybe not! :)
You can see the entire logic in [run.sh](run.sh) which uses [smeagle-db](smeagle-db) (python).

### 2. Run Manually

Once you have some libraries and have run Smeagle on those libraries to output
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

### 3. Run Interactively / Develop

To run interactively or develop, you probably want to bind the present working
directory. For the container, Smeagle is installed at `/code` and the files here are
added to `/db` so if you want to run and bind:

```bash
$ docker run -it --entrypoint bash -v $PWD:/db smeagle-db 

# run.sh will reproduce what you see above, or any of the commands within.
```

## Generate Facts

If you just want to generate facts for a single library, also within the container
you can do:

```bash
./smeagle-db facts library-name.json
```

The entire set of steps to build and shell would be:

```bash
$ docker build -t smeagle-db .
./smeagle-db facts library-name.json
$ docker run -it --entrypoint bash -v $PWD:/db smeagle-db 
```

And here is example output (and you can compare the original functions [here](https://github.com/buildsi/build-abi-test-tim/blob/main/foo.c))

```bash
./smeagle-db facts results/libfoo.so.json 
INFO:smeagle-db:Retrieving record for libfoo.so.json

%============================================================================
% Library Facts
%============================================================================

%----------------------------------------------------------------------------
% Library: libfoo.so.json
%----------------------------------------------------------------------------
abi_typelocation("libfoo.so.json","func","e","Integer","%rdi","import","0").
abi_typelocation("libfoo.so.json","func","f","Integer","%rsi","import","0").
abi_typelocation("libfoo.so.json","func","s","Struct","%rdx","import","0").
abi_typelocation("libfoo.so.json","func","a","Scalar","%rdx","import","0").
abi_typelocation("libfoo.so.json","func","b","Scalar","%rdx","import","0").
abi_typelocation("libfoo.so.json","func","d","Scalar","%rdx","import","0").
abi_typelocation("libfoo.so.json","func","g","Integer","%rcx","import","0").
abi_typelocation("libfoo.so.json","func","h","Integer","%r8","import","0").
abi_typelocation("libfoo.so.json","func","ld","Float","framebase+8","import","0").
abi_typelocation("libfoo.so.json","func","m","Float","%xmm0","import","0").
abi_typelocation("libfoo.so.json","func","y","Array","%r9","import","0").
abi_typelocation("libfoo.so.json","func","n","Float","%xmm1","import","0").
abi_typelocation("libfoo.so.json","func","i","Integer","framebase+24","import","0").
abi_typelocation("libfoo.so.json","func","j","Integer","framebase+32","import","0").
abi_typelocation("libfoo.so.json","func","k","Integer","framebase+40","import","0").
```

Please [open an issue](https://github.com/buildsi/smeagle-demo) if you have any questions!
