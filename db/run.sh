#!/bin/bash

# set package here
package=zlib

# Install every version of a package
for version in $(spack versions --safe $package); do
  spack install "$package@$version" 
done

# Make a results directory
mkdir -p ./results

# Find installed packages
for v in $(spack find --paths --no-groups $package); do

  # If we find a package path
  if [[ -e "$v" ]]; then
      specname=$(basename $v)
      
      # If no lib directory, nothing to do
      if [[ ! -e "$v/lib" ]]; then
          continue
      fi
      
      # For each package found, run smeagle
      for lib in $(find $v/lib -maxdepth 1 -name '*.so'); do
          basenamelib=$(basename $lib)
          Smeagle -l $lib > ./results/$specname-$basenamelib.json
      done
  fi
done

# Load results into smeagle database
./smeagle-db load ./results

# List what we have in the database
./smeagle-db list

# Run stability test of one library vs. the other
tests=$(ls ./results/${package}*)
./smeagle-db stability-test $tests --detail
