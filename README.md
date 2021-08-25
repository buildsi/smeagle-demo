# Smeagle Demo

This is a demo of using Smeagle to assess ABI compatibillity. This means 
we will be installing a spack package, and then running Smeagle across the 
package (and it's dependencies) to determine (or predict, because we likely will be wrong) 
which libraries will be compatible (and which libraries not). Since Smeagle is currently
not able to parse call sites, we can implement the stability tests (but not yet compatability
tests, which are usually done with a binary and library, and the binary is usually
doing something in a main function which we could not see. We will be combining:

 - The [Smeagle](https://github.com/buildsi/Smeagle) library via it's [container](https://github.com/buildsi/build-abi-containers/pkgs/container/smeagle).
 - Early models developed [here](https://github.com/buildsi/build-abi-tests/tree/main/smeagle/stability-tests) for stability testing.
 - spack for getting packages and dependencies.
 - some database? For saving results.
 
To make things easier, we will be running everything in a container, which can
be mounted to the filesystem to save the database of results. This also makes it
easier to (eventually) switch up the base environment and libraries, etc.

Toward this goal, there are two demos available:

 - [asp](asp): Which will generate facts and then run the solver clingo to show a result (this demo is now deprecated)
 - [db](db): Which will generate facts, add to an sqlite database, and then query them for the solver.
 
Of the two, the first is now considered deprecated as we've updated Smeagle, and are continue to update
the second (more robust) approach to maintaining a database.
