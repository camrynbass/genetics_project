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

# Set up the source prefix for the GnomAD data
VERSION=$VERSION
SOURCE_PREFIX=$SOURCE_PREFIX/$VERSION
EXOME_SOURCE_PREFIX="$SOURCE_PREFIX/vcf/exomes"
GENOME_SOURCE_PREFIX="$SOURCE_PREFIX/vcf/genomes"
FILE_PREFIX="gnomad.exomes.v$VERSION.sites"

declare -a chrom_array #Used to store the chromosome names

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
            chrom_array+=($line)
            chrom=$(sed -n 's/.*chr\([0-9XY]*\).*/chr\1/p')
            echo "${chrom} ${line}" >> exome_list.txt
        fi
    done < exome_list_raw.txt
    for line in $(echo $exome_list_raw.txt); do
        if [[ $line == *".vcf.bgz" ]]; then
            chrom_array+=($line)
            chrom=$(sed -n 's/.*chr\([0-9XY]*\).*/chr\1/p')
        fi
    done
    return 0
}

download_all_chromosomes(){
    for chrom in $unique_chromosomes; do
        download_single_chromosome $chrom
        analyse_chromosome $chrom
    done
return 0
}

download_single_chromosome(){
    chrom=$1
    echo "Downloading ${chrom} from ${EXOME_SOURCE_PREFIX}${chrom}.vcf.bgz to ${LOCAL_DIR}ref_data/"
    # Check if the chromosome directory used to cotain all chromosome ID specific files already exists
    if [ ! -d "$LOCAL_DIR/ref_data/$chrom" ]; then
        mkdir -p "$LOCAL_DIR/ref_data/$chrom"
    fi
    if [ ! -f "/$REF_DATA_DIR/$chrom/$FILE_PRFIX.$chrom.exome.vcf.bgz" ]; then
        # Set file names
        log_file="/$REF_DATA_DIR/$chrom/$chrom.exome.gsutil.log.txt"
        source_file="$EXOME_SOURCE_PREFIX/$FILE_PREFIX.$chrom.vcf.bgz"
        dest_file="/$REF_DATA_DIR/$chrom/$chrom.exome.vcf.bgz"
        # Download the chromosome specific file
        gsutil cp -c -L $log_file $source_file $dest_file
    fi
}

analyze_chromosome(){
    chrom=$1
    echo "Analyzing ${chrom} from ${EXOME_SOURCE_PREFIX}${chrom}.vcf.bgz to ${LOCAL_DIR}ref_data/"
    # This step takes a lot of storage- your system must be able to handle the >20 GB average size of the files
    gunzip -c "/$REF_DATA_DIR/$chrom/$FILE_PREFIX.$chrom.exome.vcf.bgz" > "/$REF_DATA_DIR/$chrom/$FILE_PREFIX.$chrom.exome.vcf"
    bcftools view /$LOCAL_DIR/ref_data/$chrom/$chrom.exome.vcf -o /$LOCAL_DIR/ref_data/$chrom/$chrom.exome.bcf -O u
    vcftools --vcf /$LOCAL_DIR/ref_data/$chrom/$chrom.exome.vcf --freq --chr 1 --out $chrom.analysis.txt --temp /$TEMP_DIR /$LOCAL_DIR/ref_data/$chrom
    plink2 --bcf /$LOCAL_DIR/ref_data/$chrom/$chrom.exome.bcf --make-bed --out /$LOCAL_DIR/ref_data/$chrom/$chrom.exome
}

# Main script execution
make_file_list
download_single_chromosome "chr21"

# Example command to download a single file
# gsutil -m cp gs://gcp-public-data--gnomad/release/4.1/vcf/exomes/gnomad.exomes.v4.1.sites.chr18.vcf.bgz /Users/cambass/Desktop/projectTemp

#
# gwas overlaps
# visually compare manhatten plots
# simple stats overlap
# 

# Compare appearance of genes in gnomad and gwas