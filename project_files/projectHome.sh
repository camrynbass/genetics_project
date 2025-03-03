#!/bin/bash

# Author: Cam Bass
# Date: 2025-02-28
# Version: 1.0
# Description: This script is used to download the GnomAD exome data from Google Cloud Storage.

# Load configuration variables
source /Users/cambass/Desktop/camrynbass.github.io/config.env

# Set up variables
LOCAL_DIR=$LOCAL_DIR
SOURCE_PREFIX=$SOURCE_PREFIX
EXOME_SOURCE_PREFIX=$EXOME_SOURCE_PREFIX

get_file_list() {
    GS_exomelist_unfiltered=$(gsutil ls $SOURCE_PREFIX/exomes)
    if [ -f exomeList.txt ]; then
        rm exomeList.txt
    fi
    # Get the list of files in the exome directory
    for line in $GS_exomelist_unfiltered; do
        if [[ $line == *".vcf.bgz" ]]; then
            echo $line >>exomeList.txt
        fi
    done
    if (( $(wc -l <exomeList.txt) == 0 )); then
        echo "No files found in $SOURCE_PREFIX/exomes"
        exit 1 # Exit with error
    fi
    return 0
}

get_chromosome_list() {
    if [ -n "$GS_exomelist_unfiltered" ]; then
        # Convert the string to an array properly
        IFS=$'\n' read -r -d '' -a exome_array <<<"$GS_exomelist_unfiltered"
        # Remove the first element of the array, which is the folder name
        unset exome_array[0]  
        # Use sed to extract unique chromosome identifiers
        unique_chromosomes=$(printf "%s\n" "${exome_array[@]}" | sed -n 's/.*chr\([0-9XY]*\).*/chr\1/p' | sort -u)
    fi
}

print_chromosomes() {
    for chrom in $unique_chromosomes; do
        echo "$chrom"
    done
}

get_file_list
get_chromosome_list

for chrom in $unique_chromosomes; do
    echo "Downloading $chrom to $LOCAL_DIR"
    gsutil -m cp "${SOURCE_PREFIX}/exomes/gnomad.exomes.v4.1.sites.${chrom}.vcf.bgz" "${LOCAL_DIR}"
done

# Example command to download a single file
#gsutil -m cp gs://gcp-public-data--gnomad/release/4.1/vcf/exomes/gnomad.exomes.v4.1.sites.chr18.vcf.bgz /Users/cambass/Desktop/projectTemp
