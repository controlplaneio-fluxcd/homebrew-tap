#!/bin/bash

binary_types=("flux-operator" "flux-operator-mcp")
operating_systems=("linux" "darwin")
architectures=("amd64" "arm64")

for binary_type in "${binary_types[@]}"; do
  cp ${binary_type}.rb.tpl ${binary_type}.rb

  sed -i "s/LATEST_RELEASE/${latest_release}/g" ${binary_type}.rb

  for operating_system in "${operating_systems[@]}"; do
    for architecture in "${architectures[@]}"; do
      placeholder=$(echo "${binary_type}_${operating_system}_${architecture}" | tr '[:lower:]' '[:upper:]')
      placeholder=$(echo "$placeholder" | sed 's/-/_/g')

      hash=$(cat checksums.txt | grep "${binary_type}_" | grep "${operating_system}" | grep "${architecture}" | awk '{print $1}')

      sed -i "s/${placeholder}/${hash}/g" ${binary_type}.rb
    done
  done
done
