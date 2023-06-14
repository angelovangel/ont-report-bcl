#! /usr/bin/env bash

# cat, compress, rename fastq files from a runfolder based on csv sample-barcode sheet
# run faster on concatenated files and make a csv plus a short html report
# cd in the run directory to execute

# expected input - fastq_pass/barcodeXX (--barcoded true) or fastq_pass (--barcoded false)
# final_summary_XX file from MinKNOW

# arg1 - csv file
# a ',' separated csv file with unix line endings. First column is barcode01, barcode02..., second column is target name 
#------------------------
# barcode01	sample1
# barcode02	sample2
#------------------------

mkdir processed

while read BARCODE SAMPLE
do
# check if dir exists 
currentdir="fastq_pass"/${BARCODE// /}
[ -d $currentdir ] && cat $currentdir/*.fastq.gz > processed/$SAMPLE.fastq.gz || echo folder ${currentdir} not found!
done < "$1"


