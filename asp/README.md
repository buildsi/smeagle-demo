# Smeagle Demo with Facts

This demo is focused on generating facts and running clingo. We don't
store anything in a database because we just need the files and then
logic program.
 
## Usage

For this demo we are going to:

1. Install all versions of a package from spack (zlib)
2. For each library that is discovered, dump model facts
3. For each pair of model facts (matching libraries of different versions) run the stability test
4. Write results to the terminal.

We can update this to be more sophisticated, e.g., reading facts into a database first,
and then creating the asp on the fly from them, but since the Smeagle software is going
to change soon I'm going to wait until after that before doing this work.

Here are the basic commands to reproduce the above:

```bash
$ docker build -t smeagle-demo .
$ docker build -t smeagle-demo .
[+] Building 17.9s (13/13) FINISHED                                                                                                                    
 => [internal] load build definition from Dockerfile                                                                                              0.0s
 => => transferring dockerfile: 668B                                                                                                              0.0s
 => [internal] load .dockerignore                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                   0.0s
 => [internal] load metadata for ghcr.io/buildsi/smeagle:0.0.0.2                                                                                  0.0s
 => [1/8] FROM ghcr.io/buildsi/smeagle:0.0.0.2                                                                                                    0.0s
 => [internal] load build context                                                                                                                 0.0s
 => => transferring context: 12.23kB                                                                                                              0.0s
 => CACHED [2/8] WORKDIR /opt                                                                                                                     0.0s
 => CACHED [3/8] RUN git clone --depth 1 https://github.com/spack/spack                                                                           0.0s
 => CACHED [4/8] WORKDIR /code                                                                                                                    0.0s
 => CACHED [5/8] COPY run.sh /code/run.sh                                                                                                         0.0s
 => CACHED [6/8] COPY smeagle-demo /code/smeagle-demo                                                                                             0.0s
 => CACHED [7/8] COPY ./test /code/test/                                                                                                          0.0s
 => [8/8] RUN apt-get install -y gringo &&     pip3 install --upgrade pip &&     pip3 install IPython clingo && wget https://raw.githubusercont  17.3s
 => exporting to image                                                                                                                            0.5s 
 => => exporting layers                                                                                                                           0.5s 
 => => writing image sha256:82d2ed1e1d2a72176a0aa30c9fc9a576a1795bf12dd8a75e39ed0b4217138ea8                                                      0.0s 
 => => naming to docker.io/library/smeagle-demo                                          
```

And run

```bash
$ docker run -it  smeagle-demo 
==> Installing zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
==> No binary for zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/c3/c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
  Fetch: 0.28s.  Build: 1.85s.  Total: 2.14s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x
==> Installing zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
==> No binary for zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/36/36658cb768a54c1d4dec43c3116c27ed893e88b02ecfcb44f2166f9c0b7f2a0d.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
  Fetch: 0.22s.  Build: 1.67s.  Total: 1.89s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv
==> Installing zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
==> No binary for zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c found: installing from source
==> Fetching https://mirror.spack.io/_source-cache/archive/17/1795c7d067a43174113fdf03447532f373e1c6c57c08d61d9e4e9be5e244b05e.tar.gz
==> No patches needed for zlib
==> zlib: Executing phase: 'install'
==> zlib: Successfully installed zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
  Fetch: 0.23s.  Build: 0.84s.  Total: 1.07s.
[+] /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-7.5.0/zlib-1.2.3-2vxddnraqwjmh6df5tanxkoalhmst24c
Comparing zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.lp with zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.lp
clingo version 5.2.2
Reading from stability.lp ...
Solving...
Answer: 1

SATISFIABLE

Models       : 1
Calls        : 1
Time         : 0.006s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.004s
Comparing zlib-1.2.8-5rhnpzmywd6woheme5edaaexeui6t7sv-libz.so.lp with zlib-1.2.11-fz2bs562jhc2spgubs3fvq25g3qymz6x-libz.so.lp
clingo version 5.2.2
Reading from stability.lp ...
Solving...
Answer: 1

SATISFIABLE

Models       : 1
Calls        : 1
Time         : 0.005s (Solving: 0.00s 1st Model: 0.00s Unsat: 0.00s)
CPU Time     : 0.005s
```

You'll see the libraries installing, and then the result of the stability model runs
printed to the screen. If you don't see any prints of missing symbols they are compatible.
