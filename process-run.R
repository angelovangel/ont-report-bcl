#!/usr/bin/env Rscript
#============
#
# this is the main script used to process ONT runs
# Input is:
# - samplesheet.tsv
# - path to ONT run folder
#  
# The script (optionally) merges/renames raw fastq files and generates a csv/html report for the samples in the samplesheet
# Output:
# - processed - folder with merged and renamed fastq files
# - stats.csv - fastq statistics per file
# - report.html
#============


library(optparse)
require(rmarkdown)

option_list <- list(
  make_option(c('--path', '-p'), help = 'path to folder with fastq files [%default]', type = 'character', default = NULL),
  make_option(c('--regex', '-r'), help = 'regex pattern to match fastq files [%default]', type = 'character', default = 'fast(q|q.gz)$'),
  make_option(c('--rename', '-n'), help = 'rename fastq files based on samplesheet [%default]', type = 'logical', default = TRUE),
  make_option(c('--sequencer', '-s'), help = "seq platform used, can be one of 'min', 'grid' or 'prom' [%default]", default = 'prom'),
  make_option(c('--outfile','-o'), help = 'name of output report file [%default]', type = 'character', default = 'report.html')
  )

opt_parser <- OptionParser(option_list = option_list)
opts <- parse_args(opt_parser)

if (is.null(opts$path)){
  print_help(opt_parser)
  stop("At least a path to a folder with fastq files is required (use option '-p path/to/folder')", call.=FALSE)
}

# change to match parameter. used in Rmd

if (opts$sequencer == 'min') {
  opts$sequencer <- 'MinION'
} else if (opts$sequencer == 'grid') {
  opts$sequencer <- 'GridION'
} else if(opts$sequencer == 'prom') {
  opts$sequencer <- 'PromethION'
}

# render the rmarkdown, using fastq-report.Rmd as template
rmarkdown::render(input = "report.Rmd",
                  output_file = opts$outfile,
                  output_dir = getwd(), # important when knitting in docker
                  knit_root_dir = getwd(), # important when knitting in docker
                  params = list(
                    path = opts$path,
                    regex = opts$regex,
                    sequencer = opts$sequencer
                  )
)
