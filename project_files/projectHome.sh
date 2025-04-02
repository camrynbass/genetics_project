#!/bin/bash

# Author: Cam Bass
# Date: 2025-02-28
# Version: 1.0
# Description: This script is used to download the GnomAD exome data from Google Cloud Storage.

# Load configuration variables
source /Users/cambass/Desktop/project_files/config.env

# Set up variables
LOCAL_DIR=$LOCAL_DIR
TEMP_DIR=$TEMP_DIR
PLINK_DIR="$LOCAL_DIR/plink"
REF_DATA_DIR="$LOCAL_DIR/ref_data"
#SOURCE_PREFIX="gs://gcp-public-data--gnomad/release/"
# gsutil -m cp gs://gcp-public-data--gnomad/release/4.1/vcf/exomes/gnomad.exomes.v4.1.sites.chr18.vcf.bgz /Users/cambass/Desktop/projectTemp
# Set up the source prefix for the GnomAD data
VERSION=$VERSION
SOURCE_PREFIX=$SOURCE_PREFIX/$VERSION
EXOME_SOURCE_PREFIX="$SOURCE_PREFIX/vcf/exomes"
GENOME_SOURCE_PREFIX="$SOURCE_PREFIX/vcf/genomes"
FILE_PREFIX="gnomad.exomes.v$VERSION.sites"

declare -a exome_array

# Add all necessary directories to the PATH
if [[ "$PATH"!=*"/$LOCAL_DIR"* ]]; then
    export PATH="$PATH:/$LOCAL_DIR/"
fi
if [[ "$PATH"!=*"/$LOCAL_DIR/ref_data"* ]]; then
    export PATH="$PATH:/$REF_DATA_DIR/"
fi
if [[ "$PATH"!=*"/$LOCAL_DIR/plink2"* ]]; then
    export PATH="$PATH:/$PLINK_DIR/"
fi

# Check if plink2 is accessible and functional
if ! command -v plink2 &> /dev/null; then
    if [ ! -d "$LOCAL_DIR/plink" ]; then
        mkdir -p "$PLINK_DIR"
    elif [ $PATH != *"/$PLINK_DIR/"* ]; then
        export PATH="$PATH:$PLINK_DIR/"
    fi
    echo "plink2 could not be found, downloading..."
    OS=$(uname)
    case "$OS" in
        Linux)
            echo "Downloading PLINK2 for Linux to /$PLINK_DIR/..."
            curl -O /$PLINK_DIR/plink2.zip "https://s3.amazonaws.com/plink2-assets/alpha6/plink2_linux_avx2_20250129.zip"
            unzip /$PLINK_DIR/plink2.zip -C /$PLINK_DIR/
            export PATH="$PATH:$PLINK_DIR/"
            ;;
        Darwin)
            echo "Downloading PLINK2 for MacOS to /$PLINK_DIR/..."
            curl -O /$PLINK_DIR/plink2.zip "https://s3.amazonaws.com/plink2-assets/alpha6/plink2_mac_arm64_20250129.zip"
            unzip /$PLINK_DIR/plink2.zip -C /$PLINK_DIR/
            export PATH="$PATH:$PLINK_DIR/"
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            echo "Downloading PLINK2 for MacOS to /$PLINK_DIR/..."
            curl -O /$PLINK_DIR/plink2.zip "https://s3.amazonaws.com/plink2-assets/alpha6/plink2_win_avx2_20250129.zip"
            unzip /$PLINK_DIR/plink2.zip -C /$PLINK_DIR/
            export PATH="$PATH:$PLINK_DIR/"
            ;;
        *)
            echo "Unknown OS: $OS. Please download PLINK2 manually and retry program execution."
            exit 1
            ;;
    esac
fi

# Function to get the list of VCF files from the exome directory
make_file_list() {
    #
    echo " " > exome_list.txt
    gsutil ls -l -h "$EXOME_SOURCE_PREFIX" > exome_list_raw.txt
    while IFS= read -r line; do
        if [[ $line == *".vcf.bgz" ]]; then
            exome_array+=($line)
            chrom=$(sed -n 's/.*chr\([0-9XY]*\).*/chr\1/p')
            echo "${chrom} ${line}" >> exome_list.txt
        fi
    done < exome_list_raw.txt
    for line in $(echo $exome_list_raw.txt); do
        if [[ $line == *".vcf.bgz" ]]; then
            exome_array+=($line)
            chrom=$(sed -n 's/.*chr\([0-9XY]*\).*/chr\1/p')
        fi
    done
    return 0
}

download_all_chromosomes(){
    for chrom in $unique_chromosomes; do
        echo "WOULD BE Downloading ${chrom} from ${EXOME_SOURCE_PREFIX}${chrom}.vcf.bgz to ${LOCAL_DIR}ref_data/"
        #gsutil cp -c -L "gsutil.$chrom.log" "${EXOME_SOURCE_PREFIX}${chrom}.vcf.bgz" "${LOCAL_DIR}/ref_data/$chrom.exome.vcf.bgz"
        #plink2 --vcf "${LOCAL_DIR}/ref_data/$chrom.exome.vcf.bgz" --make-bed --out "${LOCAL_DIR}${chrom}_2"
    done
return 0
}

download_single_chromosome(){
    chrom=$1
    #
    echo "Downloading ${chrom} from ${EXOME_SOURCE_PREFIX}${chrom}.vcf.bgz to ${LOCAL_DIR}ref_data/"
    #
    # Check if the chromosome directory used to cotain all chromosome ID specific files already exists
    if [ ! -d "$LOCAL_DIR/ref_data/$chrom" ]; then
        mkdir -p "$LOCAL_DIR/ref_data/$chrom"
    fi
    #
    log_file="/$REF_DATA_DIR/$chrom/$chrom.exome.gsutil.log.txt"
    source_file="$EXOME_SOURCE_PREFIX/$FILE_PREFIX.$chrom.vcf.bgz"
    dest_file="/$REF_DATA_DIR/$chrom/$chrom.exome.vcf.bgz"
    #
    echo "Log file: $log_file"
    echo "Source file: $source_file"
    echo "Destination file: $dest_file"
    # Download the chromosome specific file
    gsutil cp -c $source_file $dest_file
    # FIX BELOW LATER
    #if [ -f "/$REF_DATA_DIR/$chrom/$FILE_PRFIX.$chrom.exome.vcf.bgz" ]; then

        #bcftools view /$LOCAL_DIR/ref_data/$1/$1.genome.subset1000.vcf -o /$LOCAL_DIR/ref_data/$1/$1.exome.bcf -O u
        #vcftools --vcf /$LOCAL_DIR/ref_data/$1/$1.exome.subset1000.vcf --freq --chr 1 --out chr$1.analysis.txt --temp /$TEMP_DIR /$LOCAL_DIR/ref_data/$1
        #plink2 --bcf /$LOCAL_DIR/ref_data/$1/$1.exome.bcf --make-bed --out /$LOCAL_DIR/ref_data/$1/chr20.exome
    #else 
        #gsutil cp -c -L /$LOCAL_DIR/ref_data/$1/$1.genome.gsutil.log $GENOME_SOURCE_PREFIX$1.vcf.bgz /$LOCAL_DIR/ref_data/$1/$1.genome.vcf.bgz
        #bcftools view /$LOCAL_DIR/ref_data/$1/$1.genome.subset1000.vcf -o /$LOCAL_DIR/ref_data/$1/$1.genome.bcf
    #fi
    #gsutil cp -c -L /$LOCAL_DIR/ref_data/$1/$1.gsutil.log $EXOME_SOURCE_PREFIX$1.vcf.bgz /$LOCAL_DIR/ref_data/$1/$1.exome.vcf.bgz
    #if [[ ! -a "$LOCAL_DIR/ref_data/$1.exome.vcf" ]]; then
    #    gunzip -c /$LOCAL_DIR/ref_data/$1.exome.vcf.bgz > /$LOCAL_DIR/ref_data/$1.exome.vcf
    #fi
    #gsutil cp -c -L /$LOCAL_DIR/ref_data/gsutil.$1.log $EXOME_SOURCE_PREFIX$1.vcf.bgz $LOCAL_DIR/ref_data/$1.exome.vcf.bgz
    #bcftools stats /$LOCAL_DIR/ref_data/$1/$1.exome.vcf.bgz | echo
    #plink2 --vcf /$LOCAL_DIR/ref_data/$1.exome.vcf.bgz --make-bed --out /$LOCAL_DIR/$1
}

# Main script execution
make_file_list
download_single_chromosome "chr21"

# Example command to download a single file
# gsutil -m cp gs://gcp-public-data--gnomad/release/4.1/vcf/exomes/gnomad.exomes.v4.1.sites.chr18.vcf.bgz /Users/cambass/Desktop/projectTemp

# PLINK2
# 

# gwas overlaps
# visually compare manhatten plots
# simple stats overlap
# 

# Compare appearance of genes in gnomad and gwas