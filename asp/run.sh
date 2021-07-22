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
          Smeagle -l $lib -f asp > ./results/$specname-$basenamelib.lp
      done
  fi
done

# For each pair, run the modelb
for result1 in $(ls ./results); do
    for result2 in $(ls ./results); do
       if [[ "$result1" != "$result2" ]]; then
           printf "Comparing ${result1} with ${result2}\n"
           clingo --out-ifs=\\n stability.lp ./results/$result1 ./results/$result2   
       fi
    done
done
